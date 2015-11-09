---
layout: post
title: Project 10
due: "Nov 16, 11:59pm"
categories: [projects]
---

# Project 10

- Read pp. 121-172

- Create a repository on Bitbucket named exactly `csci201-project-10`. Invite me (`joshuaeckroth`) as a reader.

## Task 1

Create a VM language to assembly language translator for the following VM commands:

```
push constant [num]
push static [num]
push local [num]
push argument [num]
push temp [num]

pop static [num]
pop local [num]
pop argument [num]
pop temp [num]

add
sub
neg
and
or
not

lt
gt
eq

label
if-goto
goto
```

Your program must read the VM file given on the command line and print output to stdout. Do not print output to a file. Do not read the file from user after your program is running; read the file from the command line.

Example VM programs may be found in [project-10.zip](/code/project-10.zip). Test the ASM programs that your translator produces. The ASM program must pass all test cases in the ZIP file. Use the CPU emulator to run the test cases (since that is what we used to test assembly code).

Be sure to submit your translator (written in whatever language) not just the resulting ASM files. I will reproduce the ASM files with the VM examples in the ZIP.
