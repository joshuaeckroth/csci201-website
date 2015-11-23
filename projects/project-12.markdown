---
layout: post
title: Project 12
due: "Dec 9, 11:59pm"
categories: [projects]
---

# Project 12

This is the final project. You will translate code written in a high-level imperative language to VM code.

- Create a repository on Bitbucket named exactly `csci201-project-12`. Invite me (`joshuaeckroth`) as a reader.

## Task 1

Translate Sprinkles (an imperative language) to VM (a stack language). Look at the code provided in the ZIP, and find the TODOs.

Turn in `Sprinkles.g4` and `SprinklesVMVisitor.java`. I give you `Sprinkles.java` below. ANTLR generates the rest of the needed files. See the bottom of the [ANTLR](/notes/antlr.html) notes for info about compiling and running your code.

Test the resulting VM code with these test scripts: [project-12.zip](/code/project-12.zip) (not ready yet). In the ZIP you will also find some example Sprinkles code and corresponding VM translations.

## Extra credit

Add support for global variables (using VM `static 0` etc.) with special variable names that start are written `_g0`, `_g1`, ... or some other format.

Add support for `for` loops:

```
for(i = 0; i < 10; i = i + 1)
    [statement]
    [statement]
    ...
end
```

Add support for a `switch` statement:

```
switch(expr) // any expression
case 1:
    [statement]
    [statement]
    ... // no break in this case
case x*5: // any expression
    [statement]
    [statement]
    ...
    break
default:
    [statement]
    [statement]
    ...
end
```

Write a parse tree visitor to translate from Sprinkles to Java code (or Python, or C, or whatever). The Java code should be executable. Note that every numeric value has type `int`.

Implement some optimizations, e.g., computing some expressions in the translator and just saving the answer in the VM code (e.g., computing `5+2` ahead of time), inlining short functions (copy-pasting function code to the place it is called and avoiding the function call), eliminating code that does not contribute to a function's return value (e.g., if `x=mult(a,b)` occurs in the function but the function finishes with `return 5`, then there was no reason to compute `x`...), etc.

{% comment %}
You can translate the resulting VM code to assembler using [VMTranslator.jar](/code/VMTranslator.jar) from [Gilad Goldberg & Avishai Lazar](https://code.google.com/p/nand2tet-gilad-avishai/source/browse/#svn%2Ftrunk%2Fnand2tet.ex8%2Fsrc), unless you want to use your own VM-assembler translator from project 11.

To use `VMTranslator.jar`, put your VM files in a folder, then run:

```
java -jar VMTranslator.jar [folder name]
```
{% endcomment %}

## The Sprinkles language

The top rule of the Sprinkles grammar should be `prog`. A program consists of a series of function definitions, and nothing more. Inside each function definition is a list of statements, plus `return` or `exit`.

### Example code

Multiplication:

```
function main()
    x = 7
    y = 5
    exit mult(x, y)
end

function mult(a, b)
    sum = 0
    while b > 0 do
        sum = sum + a
        b = b - 1
    end
    return sum
end
```

Recursive multiply works, too:

```
function mult(a, b)
    answer = 0
    if b == 0 then
        answer = 0
    else
        answer = a + mult(a, b-1) // recursion!
    end
    return answer
end
```

### Function definitions

```
function foo(a, b, c)
    [statement]
    [statement]
    ...
    return [expression]
end
```

Function parameters (`a, b, c` above) should be treated as local variables. The values come from `argument 0` etc. in the VM language, but should be popped immediately into `local 0` etc. when the function code begins.

Special case for `exit` (intended to be used on `main`):

```
function main()
    [statement]
    [statement]
    ...
    exit [expression]
end
```

Either `return` or `exit` must be the last statement before `end`. Every function must have `return` or `exit`. If a function uses `return`, then it pushes a value on the stack, which may well be ignored. If you want a `void` function, just `return 0` or whatever value.

### Statements

A function consists of statements. There are four kinds of statements:

- `if` statement
- `while` statement
- assignment statement (`x = ...`)
- function call

### If's

Note, conditional expressions are not different than other expressions. They should have the value -1 or 0, but in actuality, any non-zero value should be treated as `true`.

```
if [conditional expression] then
    [statement]
    [statement]
    ...
end
```

```
if [conditional expression] then
    [statement]
    [statement]
    ...
else
    [statement]
    [statement]
    ...
end
```

### While's

```
while [conditional expression] do
    [statement]
    [statement]
    ...
end
```

### Assignment

```
x = 55
y = x + 55 * mult(5, b)
```

All variables mentioned should be locals (no statics/globals or temps).

### Function calling

```
foo(2, 3, x+y)
```

Inside the parens, for each position (separated by commas), any expression may be present.

### Expressions

Expressions have a value, i.e., a final value is sitting on the stack after the expression is computed. Expressions may be:

- '!expr' operator for negation
- 'expr + expr', 'expr - expr', etc. for various operators: `+, -, &, |, >, >=, <, <=, ==, !=`
- a function call (which leaves a return value on the stack)
- a number (integers only)
- a negation of another expression
- a local variable (whose value is pushed on the stack)
- another expression in parentheses

## Hints

Here are some snippets of code for the various files you need to create. Also look at the [ANTLR4](/notes/antlr4.html) notes for the complete calculator example.

### Grammar (Sprinkles.g4)

```
grammar Sprinkles;

prog:   ( func )*
        EOF
    ;


func:   'function' ID funcparams
        statementList
        (exit|ret)
        'end'
    ;

statementList
    :   (ifStatement|whileStatement|assignmentStatement|funcCall)*
    ;

ret :   'return' expr
    ;

exit:   'exit' expr
    ;



// TODO: if and while statement rules...



assignmentStatement
    :   ID '=' val=expr
    ;

funcCall
    :   ID '(' exprList? ')'
    ;

exprList
    :   expr (expr|(',' expr))*
    ;

expr:   '(' expr ')'
    |   op='!' right=expr

// TODO add +, -, <=, >=, etc. operators

    |   funcCall
    |   var=ID
    |   num=INT
    |   neg='-' right=expr
    ;    

INT :   DIGIT+
    ;

ARRAYPOS:
    DIGIT+
    ;

ID  :   '.' (LETTER|'_'|'.') (LETTER|DIGIT|'_'|'.')*
    |   LETTER (LETTER|DIGIT|'_'|'.')*
    ;

funcparams
    :   '(' ID (',' ID)* ')'
    |   '(' ')'
    ;

WS  :   [ \t\n\r]+ -> skip ;

COMMENT:
    '//' .*? '\n' -> skip ;

fragment
DIGIT:  '0'..'9';
fragment
LETTER: [a-zA-Z] ;
```

### Main file (Sprinkles.java)

This file is totally uninteresting, so here it is in its entirety. It translates the file given on the command line. It assumes the root of the grammar is called `prog`.

{% highlight java %}
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;


public class Sprinkles {
	public static void main(String[] args) throws Exception {
		String inputFile = args[0];
		InputStream is = new FileInputStream(inputFile);
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		ANTLRInputStream input = new ANTLRInputStream(br);
		SprinklesLexer lexer = new SprinklesLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		SprinklesParser parser = new SprinklesParser(tokens);
		SprinklesParser.ProgContext tree = parser.prog();
		String vmcode = new SprinklesVMVisitor().visit(tree);
		System.out.println(vmcode);
	}
}
{% endhighlight %}

### Tree visitor (SprinklesVMVisitor.java)

This file actually builds the VM code as a big string, based on which part of the parse tree is being handled. A different function is needed for each rule of the grammar.

Here is the visitor for root `prog` rule. Note how a `StringBuilder` is used to build a final string holding all the translated VM code. Each function definition is visited and the result appended to the string. Once all function definitions have been visited, the final string is the complete program for this file.

{% highlight java %}
public String visitProg(SprinklesParser.ProgContext ctx) {
	StringBuilder sb = new StringBuilder();
	for(SprinklesParser.FuncContext func : ctx.func()) {
		sb.append(this.visit(func) + "\n");
	}
	return sb.toString();
}
{% endhighlight %}

Here is the code for visiting a `statementList`. Note how each child statement is visited and appended.

{% highlight java %}
public String visitStatementList(SprinklesParser.StatementListContext ctx) {
	StringBuilder sb = new StringBuilder();
	for(int i = 0; i < ctx.getChildCount(); i++) {
		sb.append(this.visit(ctx.getChild(i)));
	}
	return sb.toString();
}
{% endhighlight %}

Here is code for visiting expressions.

{% highlight java %}
public String visitExpr(SprinklesParser.ExprContext ctx) {
    StringBuilder sb = new StringBuilder();

    // some expression handling, such as:
    if(ctx.op.getText() == "!") {
        sb.append(this.visit(ctx.right));
        sb.append("not\n");
    }
    else if(ctx.op.getText() == "+") {
        sb.append(this.visit(ctx.left));
        sb.append(this.visit(ctx.right));
        sb.append("add\n");
    }
    else if(ctx.num != null) {
        sb.append("push constant " + ctx.num.getText() + "\n");
	}

    // TODO handle rest of operators...


    return sb.toString();
}
{% endhighlight %}

The `exit [expr]` statement just puts an infinite loop in its place computing the expression (and leaving its value on the stack).

{% highlight java %}
public String visitExit(SprinklesParser.ExitContext ctx) {
	StringBuilder sb = new StringBuilder();
	sb.append(this.visit(ctx.expr()));
	sb.append("label " + lookupLabel(ctx) + "\n");
	sb.append("goto " + lookupLabel(ctx) + "\n");
	return sb.toString();
}
{% endhighlight %}
