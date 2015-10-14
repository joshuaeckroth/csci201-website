---
layout: post
title: Project 7
due: "Oct 21, 11:59pm"
categories: [projects]
---

# Project 7

- **Read Chapter 6**
  - Here are some free chapters: [http://www.nand2tetris.org/chapters/](http://www.nand2tetris.org/chapters/)

- Create a repository on Bitbucket named exactly `csci201-project-07`. Invite me (`joshuaeckroth`) as a reader.

## Task

Write an assembler. This project differs from the book's description in several ways:

1. You are not required to handle labels `(FOO)` or variables `@foo`. The test files in the ZIP below do not include any labels or variables. Thus, your assembler can be "one pass" rather than "two pass" (only needs to scan the assembly code once, not twice).
2. You must support this additional syntax: `M[#]` where `#` is some integer (>=0). For example, `D=M[702]` and `M[100]=D+1` and so on. Feel free to use the `A` register (clobbering its prior value) to support this syntax. The `M[#]` syntax will never appear with another use of `M` or a jump.
3. Your assembler must compile and run on Linux and/or Mac OS X, and must accept the ASM filename on the command line, and print the binary output and no other messages.
4. Use any programming language you wish. Additional pleasure will be had if it's obscure. Possibly include a README advising me how to compile your program.

The input files may contain comments and whitespace. Your assembler should ignore those.

Here is a [ZIP of test files](/code/project-07.zip). For each `.asm` file there is a desired output `.hack` file. Compare your output to the `.hack` output (using the `diff` command line utility, or similar).

P.S. For what it's worth, my assembler coded in Perl required 12 lines of code, ignoring the tables for ALU instructions and jumps. Regular expressions (might be) your friend.

## Extra credit

Write a disassembler that translates machine language back to assembly language. Use the same example files. (+1pt)
