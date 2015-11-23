---
layout: post
title: ANTLR
---

# ANTLR

> ANTLR is a powerful parser generator that you can use to read, process, execute, or translate structured text or binary files. It’s widely used in academia and industry to build all sorts of languages, tools, and frameworks. Twitter search uses ANTLR for query parsing, with over 2 billion queries a day. The languages for Hive and Pig, the data warehouse and analysis systems for Hadoop, both use ANTLR. Lex Machina uses ANTLR for information extraction from legal texts. Oracle uses ANTLR within SQL Developer IDE and their migration tools. NetBeans IDE parses C++ with ANTLR. The HQL language in the Hibernate object-relational mapping framework is built with ANTLR. ([source](http://www.antlr.org/about.html))

We'll be using version 4. Download [antlr-4.5.1-complete.jar](/code/antlr-4.5.1-complete.jar).

More applications are mentioned on the [Wikipedia page](https://en.wikipedia.org/wiki/ANTLR).

## Overview

Writing translators (which includes compilers) is hard. You know this from experience writing an assembler-to-binary and VM-to-assembly translator. In both of those cases, the translation was linear: a single line of input translated to one or a few lines of output. Once the output was generated, you could move on to the next line of input. Each line of input had no impact on how the prior or following lines would be translated

But more complex (and more useful) languages are typically nested languages. Expressions with multiple operations (+, -, *, /, etc.), expressions within parentheses, loops inside if's, if's inside loops, loops inside loops inside functions!

Just translating the expression `-((3-1)*(2+7))` into VM code is troublesome. VM code is a stack language. But the expression is nested (not in stack form). The negation must happen last but it is the first character in the input. The stack-language version (e.g., Forth) would be: `3 1 - 2 7 + * neg`. The result in VM code should be (assuming `mult` exists as a VM operation):

```
push constant 3
push constant 1
sub
push constant 2
push constant 7
add
mult
neg
```

The order is significantly different than the input. The order actually represents the "parse tree," which respects parentheses. The VM code contains left-subtree code followed by right-subtree code, which is then followed by the actual operator (`add`, `sub`, `neg`). (The `-` negation operator out front only has a right-subtree.)

![-((3-1)*(2+7))](/images/calc/calc-tree3.png)

**No fear.** We can easily translate a nested language into a stack language, or whatever else, by parsing the input into a tree and then flattening that tree into a list of VM code commands (or Forth commands or whatever). All we need to do is write a grammar, then a tree visitor. The ANTLR tool will generate all the (horrendously complicated) parsing code for our specific grammar.

### Grammars

ANTLR supports grammars written in [Extended Backus-Naur Form](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_Form) (EBNF). The structure of the input language (which will be translated to something else) is expressed in a list of rules. Each rule has one or more patterns that it matches. Vertical bars `|` mean alternative patterns for the rule.

Here is a snippet of the calculator example below:

```
expr:   left=expr op='%'
    |   left=expr op='^' right=expr
    |   left=expr op=('*'|'/') right=expr
    |   left=expr op=('+'|'-') right=expr
    |   neg='-' right=expr
    |   funcCall
    |   NUMBER
    |   '(' expr ')'
    ;
```

This snippet states the an expression (`expr`) has one of the following patterns:

- an expression followed a `%` sign
- a `^` sign between two expressions
- a `*` or `/` sign between two expressions
- a `+` or `-` sign between two expressions
- a `-` sign in front of an expression
- a function call (e.g., `foo(5, 2)`)
- a number (e.g., `55`)
- or an expression inside parentheses

Note the rule is recursive. This is how we support nesting like `-((3-1)*(2+7))`. The parse tree above shows how the `expr` matched that expression.

Some notes:

We can name certain parts of the patterns in order to easily refer to them in our visitor code. Examples above include `left=...` and `op=...`.

An ALL-CAPS rule means the rule won't be added to the parse tree, but we can refer to the rule (and get its matching text for translation) in the tree visitor code. Example:

```
NUMBER
    :   DIGIT* '.' DIGIT*
    |   DIGIT+
    |   CONSTANT
    ;
```

Note, `*` means "any number of these, including possibly none" and `+` means "at least one of these."

A "fragment" rule is only used by the grammar to help define other rules. A fragment does not even exist as an accessible property on nodes in the parse tree. Example:

```
fragment
DIGIT:  '0'..'9';
```

### Lexers

ANTLR will generate a "lexer" from the grammar. A lexer reads an input file and translates the symbols in that file into a stream (list) of "tokens." The grammar is full of tokens: `+`, `-`, etc. Here are the tokens for `-((3-1)*(2+7))`. Note how the positions are specified for each token. The numbers in `<brackets>` indicate internal IDs for the various unique tokens (they are unimportant to us).

```
[@0,0:0='-',<6>,1:0]
[@1,1:1='(',<7>,1:1]
[@2,2:2='(',<7>,1:2]
[@3,3:3='3',<12>,1:3]
[@4,4:4='+',<5>,1:4]
[@5,5:5='1',<12>,1:5]
[@6,6:6=')',<8>,1:6]
[@7,7:7='*',<3>,1:7]
[@8,8:8='(',<7>,1:8]
[@9,9:9='2',<12>,1:9]
[@10,10:10='+',<5>,1:10]
[@11,11:11='7',<12>,1:11]
[@12,12:12=')',<8>,1:12]
[@13,13:13=')',<8>,1:13]
[@14,15:14='<EOF>',<-1>,2:0]
```

### Parsers

ANTLR will also generate a parser from the grammar. A parser takes a stream of tokens (produced by the lexer) and generates a parse tree according to the rules in the grammar. The diagram of the tree above is an example parse tree.

### Tree visitors

Finally, given the parse tree, the last step is to flatten the parse tree into a list of statements in the target language (in our case, VM code). To do so, we can walk down the tree with a collection of "visitor" functions. We start at the top root of the tree, then look at each node. The visitor for a node calls the visitors of its children. See the calculator example below for details.

### Translators vs. compilers

We have been using the terminology "translator" rather than "compiler" just to be politically correct. To be a compiler, a program usually must translate a source language into machine code. Whether or not that distinction is important to you dictates whether you call a program a translator or compiler. Our use of ANLTR (lexer + parser + tree visitor) makes our approach otherwise very close to a compiler.

## Calculator example

We'll build a simple calculator as an example. We'll define a grammar and a tree visitor. The result of the tree visitor is not code in another language (e.g., VM code) but rather the result of the computation. In that sense, this is an "interpreter" rather than a "compiler" because the result is a value not a program to be executed later.

### Grammar (Calc.g4)

Note that the order of definitions in a rule matter. For example, if `'%'` comes after `'+'`, then `55% + 100%` is computed as `1.0055`, i.e., `(55% + 100)%`. If `'%'` it comes before `'+'` then we get correct behavior: `55% + 100% => 1.55`. We order `+` and `-` after `*` and `/` for this same reason. The first matching rule wins.

```
grammar Calc;

prog:   expr
    ;

expr:   left=expr op='%'
    |   left=expr op='^' right=expr
    |   left=expr op=('*'|'/') right=expr
    |   left=expr op=('+'|'-') right=expr
    |   neg='-' right=expr
    |   funcCall
    |   NUMBER
    |   '(' expr ')'
    ;

funcCall
    :   f='sin' '(' expr ')'
    |   f='cos' '(' expr ')'
    |   f='log' '(' expr ')'
    ;

NUMBER
    :   DIGIT* '.' DIGIT*
    |   DIGIT+
    |   CONSTANT
    ;

fragment
DIGIT:  '0'..'9';

CONSTANT
    :   'pi'
    |   'e'
    ;

WS  :   [ \t\n\r]+ -> skip;
```

#### Diagrammatic form

These are [railroad diagrams](https://en.wikipedia.org/wiki/Syntax_diagram). I used [this tool](https://github.com/bkiers/rrd-antlr4) to generate them.

**prog**

![prog](/images/calc/prog.png)

**expr**

![expr](/images/calc/expr.png)

**funcCall**

![funcCall](/images/calc/funcCall.png)

**NUMBER**

![NUMBER](/images/calc/NUMBER.png)

**DIGIT**

![DIGIT](/images/calc/DIGIT.png)

**CONSTANT**

![CONSTANT](/images/calc/CONSTANT.png)

#### Example parse trees

These are generated by ANTLR4 with the following command (or something similar):

```
echo "5+2*3" | java -cp antlr-4.5.1-complete.jar:. \
  org.antlr.v4.gui.TestRig Calc prog -ps calc-tree1.ps
```

Input: `5+2*3`

![5+2*3](/images/calc/calc-tree1.png)

Input: `-(sin(pi)+log(e^(5/2)))`

![-(sin(pi)+log(e^(5.7/-22.0)))](/images/calc/calc-tree2.png)

### Main file (Calc.java)

The `main()` function reads a line of input from `System.in` and feeds it into the generated lexer. The lexer produces a stream of tokens, which is fed into the generated parser. The parser gives back a parse tree. Finally, our custom tree visitor (`CalcExprVisitor`) flattens to the tree to a final value. This value is printed, and another line of input is read.

{% highlight java %}
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.util.Scanner;

public class Calc {
    public static void main(String[] args) throws Exception {
        Scanner in = new Scanner(System.in);
        while(in.hasNext()) {
            String s = in.nextLine();
            ANTLRInputStream input = new ANTLRInputStream(s);
            CalcLexer lexer = new CalcLexer(input);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            CalcParser parser = new CalcParser(tokens);
            CalcParser.ProgContext tree = parser.prog(); // root of grammar
            Double result = new CalcExprVisitor().visit(tree);
            System.out.println("=> " + result);
        }
    }
}
{% endhighlight %}

### Visitor (CalcExprVisitor.java)

The visitor is where most of the work takes place. Each `visit*` function handles a particular rule in the grammar. Should the rule be encountered while visiting the nodes of the parse tree, the appropriate `visit*` function will be called. Each such function should evaluate the remainder of the tree from that point down, and return the resulting value for the subtree. Obviously, you want use recursion as much as possible, and only handle a single action at a time.

Visiting starts at `visitProg` since `prog` was the root of the grammar. We know `prog` is just an `expr` so the `visitProg` function simply returns whatever happens when the first `expr` is visited.

Now we are in the `visitExpr` function. There are different situations in the `expr` rule. We might have a unary operator, a binary operator, a negation, a function call, a number, or a nested expression in parentheses. We can tell which case we have by looking at whether `ctx.op` is non-null and what it's value is (`ctx.op.getText())`, whether `ctx.neg` is non-null, etc. We named various parts of the rule in the grammar so we could easily identify which case we're in:

```
expr:   left=expr op='%'
    |   left=expr op='^' right=expr
    |   left=expr op=('*'|'/') right=expr
    |   left=expr op=('+'|'-') right=expr
    |   neg='-' right=expr
    |   funcCall
    |   NUMBER
    |   '(' expr ')'
    ;
```

Here is the code:

{% highlight java %}

public class CalcExprVisitor extends CalcBaseVisitor<Double>
                             implements CalcVisitor<Double> {

    public Double visitProg(CalcParser.ProgContext ctx) {
        return this.visit(ctx.expr());
    }

    public Double visitExpr(CalcParser.ExprContext ctx) {
        Double result = 0.0;

        if(ctx.neg != null) {
            result = -this.visit(ctx.expr().get(0));
        }

        else if(ctx.op != null) {
            if(ctx.right == null) {
                Double l = this.visit(ctx.left);
                switch(ctx.op.getText()) {
                case "%": result = l*0.01; break;
                }
            } else {
                Double l = this.visit(ctx.left);
                Double r = this.visit(ctx.right);
                
                switch(ctx.op.getText()) {
                case "+": result = l+r; break;
                case "-": result = l-r; break;
                case "*": result = l*r; break;
                case "/": result = l/r; break;
                case "^": result = Math.pow(l,r); break;
                }
            }

        } else if(ctx.funcCall() != null) {
            result = this.visit(ctx.funcCall());

        } else if(ctx.NUMBER() != null) {
            switch(ctx.NUMBER().getText()) {
            case "pi": result = Math.PI; break;
            case "e": result = Math.E; break;
            default: result = Double.parseDouble(ctx.NUMBER().getText());
            }

        } else {
            result = this.visit(ctx.expr().get(0));
        }

        return result;
    }

    public Double visitFuncCall(CalcParser.FuncCallContext ctx) {
        Double result = 0.0;
        Double expr = this.visit(ctx.expr());

        switch(ctx.f.getText()) {
        case "sin": result = Math.sin(expr); break;
        case "cos": result = Math.cos(expr); break;
        case "log": result = Math.log(expr); break;
        }

        return result;
    }
}
{% endhighlight %}

### Building the calculator example

First, use ANTLR4 to generate the lexer, parser, and default (empty) visitor from the grammar (step 1), then compile all the Java source including code we wrote (step 2), and finally run the result (step 3).

Of course, the [antlr-4.5.1-complete.jar](/code/antlr-4.5.1-complete.jar) file is needed.

1. Generate parser/lexer/visitor from grammar: `java -jar antlr-4.5.1-complete.jar -visitor -no-listener Calc.g4`
    - This command generates:
    - `Calc.tokens`: list of tokens the lexer recognizes
    - `CalcBaseVisitor.java`: empty implementation of tree visitor
    - `CalcLexer.java`: subclass of ANTLR4 `Lexer` that has calculator grammar specific code for splitting input into tokens
    - `CalcParser.java`: subclass of ANTLR4 `Parser` that builds a parse tree out of the lexer's token stream
    - `CalcVisitor.java`: interface for any tree visitor that works with the calculator grammar

2. Compile all code: `javac -cp antlr-4.5.1-complete.jar:. *.java`

3. Run program: `java -cp antlr-4.5.1-complete.jar:. Calc`

If you change the grammar, repeat steps 1-3. If you change the Java code, repeat steps 2-3.

