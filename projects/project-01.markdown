---
layout: post
title: Project 1
due: "Aug 31, 11:59pm"
categories: [projects]
---

# Project 1

- **Read Chapter 1 and Appendix A.**

- Create a repository on Bitbucket named exactly `csci201-project-01`. Invite me (`joshuaeckroth`) as a reader.

Implement the following logic gates by writing an HDL file for each. Start with the HDL templates provided. Be sure to test your implementations with the corresponding test scripts.

You may only use the builtin Nand gate and any other gates you correctly implement during this project.

## Gates to implement

- Not gate, HDL file [`Not.hdl`](/code/project-01/Not.hdl). Test script: [`Not.tst`](/code/project-01/Not.tst), and comparison output: [`Not.cmp`](/code/project-01/Not.cmp).
- And gate, HDL file [`And.hdl`](/code/project-01/And.hdl). Test script: [`And.tst`](/code/project-01/And.tst), and comparison output: [`And.cmp`](/code/project-01/And.cmp).
- Or gate, HDL file [`Or.hdl`](/code/project-01/Or.hdl). Test script: [`Or.tst`](/code/project-01/Or.tst), and comparison output: [`Or.cmp`](/code/project-01/Or.cmp).
- Xor gate, HDL file [`Xor.hdl`](/code/project-01/Xor.hdl). Test script: [`Xor.tst`](/code/project-01/Xor.tst), and comparison output: [`Xor.cmp`](/code/project-01/Xor.cmp).
- Mux gate, HDL file [`Mux.hdl`](/code/project-01/Mux.hdl). Test script: [`Mux.tst`](/code/project-01/Mux.tst), and comparison output: [`Mux.cmp`](/code/project-01/Mux.cmp).
- DMux gate, HDL file [`DMux.hdl`](/code/project-01/DMux.hdl). Test script: [`DMux.tst`](/code/project-01/DMux.tst), and comparison output: [`DMux.cmp`](/code/project-01/DMux.cmp).
- Or16 gate, HDL file [`Or16.hdl`](/code/project-01/Or16.hdl). Test script: [`Or16.tst`](/code/project-01/Or16.tst), and comparison output: [`Or16.cmp`](/code/project-01/Or16.cmp).
- And16 gate, HDL file [`And16.hdl`](/code/project-01/And16.hdl). Test script: [`And16.tst`](/code/project-01/And16.tst), and comparison output: [`And16.cmp`](/code/project-01/And16.cmp).
- Or8Way gate, HDL file [`Or8Way.hdl`](/code/project-01/Or8Way.hdl). Test script: [`Or8Way.tst`](/code/project-01/Or8Way.tst), and comparison output: [`Or8Way.cmp`](/code/project-01/Or8Way.cmp).
- Eq gate, HDL file [`Eq.hdl`](/code/project-01/Eq.hdl). Test script: [`Eq.tst`](/code/project-01/Eq.tst), and comparison output: [`Eq.cmp`](/code/project-01/Eq.cmp).
- ConstantZero gate, HDL file [`ConstantZero.hdl`](/code/project-01/ConstantZero.hdl). Test script: [`ConstantZero.tst`](/code/project-01/ConstantZero.tst), and comparison output: [`ConstantZero.cmp`](/code/project-01/ConstantZero.cmp).
- ConstantOne gate, HDL file [`ConstantOne.hdl`](/code/project-01/ConstantOne.hdl). Test script: [`ConstantOne.tst`](/code/project-01/ConstantOne.tst), and comparison output: [`ConstantOne.cmp`](/code/project-01/ConstantOne.cmp).

[Download a ZIP file containing all of the above](/code/project-01.zip), including files for gates that I am not asking you to implement.

## Grading

A gate is considered correct if it passes all of the tests defined in its corresponding `.tst` script and `.cmp` comparison output.

- All gates correct: 5 pts
- At least 10 gates correct: 4 pts
- At least 8 gates correct: 3 pts
- At least 6 gates correct: 2 pts
- At least 2 gates correct: 1 pts
- 0 gates correct: 0 pts

## Extra credit

If you implement your gates with the fewest low-level gates possible (fewest "PARTS" in the HDL file), you receive extra credit.

- All gates are as simple as possible: +3 pts
- At least 6 gates are as simple as possible: +2 pts
- At least one gate is as simple as possible: +1 pt

