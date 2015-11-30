---
layout: post
title: Final review (incomplete)
---

# Final review (incomplete)

The final exam will be on paper. You can bring a 5x7 inch notecard fill with notes front and back. You will see questions like you see on this review.

## Combinational logic

Diagram an OR gate out of NAND gates. Here is the diagram for a NAND gate:

![NAND](/images/nand.png)

Using AND/OR/NOT gates, diagram a 4-way MUX. Here are the diagrams for AND/OR/NOT:

![AND/OR/NOT](/images/and-or-not.jpg)

Write the integer version of the binary number (in 8-bit 2's complement) 01101000. Do the same with 11101110. Now find the negation of 00101000, and write in binary form.

Using AND/OR/NOT gates, diagram a 2-bit adder. Label the "overflow" bit.

## Sequential logic

Using AND/OR/NOT and the DFF gate, diagram a Bit gate. Recall a Bit has an input, a load bit, and an output.

Describe the role of the PC gate.

Using a RAM8 gate (and no other RAM gates), diagram a RAM32 gate. Label the other gates you use.

Explain why we have Register gates in a modern machine and do not just use RAM for everything.

## Assembly language

Write a chunk of assembly code that computes:

```
if RAM[5] >= RAM[4] then
    RAM[0] = -10
else
    RAM[0] = RAM[4] + RAM[5]
end
```

Give the value that RAM[0] contains after this code executes:

```
@2
D=A
@0
MD=D-1
A=D-1
MA=M+1
```

## VM language

Assuming the stack pointer starts at 275, what is the value of the stack pointer (i.e., RAM[0]) after these operations:

```
push constant 0
push constant 10
push constant 20
eq
if-goto L1
push constant 30
add
label L1
pop local 1
sub
push constant 40
neg
push constant 50
add
```

Write the code needed to call the function `f1` with three arguments: 1, 5, 2.

Write assembly code that performs the "push constant 20" operation.

Write assembly code that performs the "if-goto L1" operation.

## Grammars, lexers, parsers, tree visitors

Describe the input and output of a "lexer."

Describe the input and output of a tree visitor (for a translator, like we did for Sprinkles->VM).

(design a grammar for very small syntax examples)

(given a parse tree and some visitor functions, find the final output after visiting the tree from the root)


