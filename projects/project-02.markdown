---
layout: post
title: Project 2
due: "Sep 9, 11:59pm"
categories: [projects]
---

# Project 2

- **Read Chapter 2.**

- Create a repository on Bitbucket named exactly `csci201-project-02`. Invite me (`joshuaeckroth`) as a reader.

Implement the following logic gates by writing an HDL file for each. Start with the HDL templates provided. Be sure to test your implementations with the corresponding test scripts.

You may use any gate described in Chapter 1: `Nand, Not, And, Or, Xor, Mux, DMux, Not16, And16, Or16, Mux16, Or8Way, Mux4Way16, Mux8Way16, DMux4Way, DMux8Way`, plus whatever gates you implement in this project.

## Gates to implement

- `HalfAdder`
- `FullAdder`
- `Add16`
- `Inc16`
- `ALU`

[Download a ZIP file containing the necessary files](/code/project-02.zip).

## Grading

A gate is considered correct if it passes all of the tests defined in its corresponding `.tst` script and `.cmp` comparison output.

- All gates correct: 5 pts
- Only `ALU` correct: 3 pts
- All but `ALU` correct: 2 pts
- Just `HalfAdder` and/or `FullAdder`: 1pt
- No gates correct: 0 pts

## Extra credit

If you implement your gates with the fewest gates possible (fewest "PARTS" in the HDL file), you receive extra credit.

- `ALU` as simple as possible: +2 pts
- `FullAdder` or `Add16` as simple as possible: +1 pt


