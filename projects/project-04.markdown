---
layout: post
title: Project 4
due: "Sep 23, 11:59pm"
categories: [projects]
---

# Project 4

- **Read Chapter 4 and the [Assembly Language notes](/notes/assembly-language.html).**
  - Here are some free chapters: [http://www.nand2tetris.org/chapters/](http://www.nand2tetris.org/chapters/)

- Create a repository on Bitbucket named exactly `csci201-project-03`. Invite me (`joshuaeckroth`) as a reader.

Write the following programs in the Hack assembly language. Test your programs with the supplied test scripts in the CPU Emulator program.

## Programs to write

- `Add4` -- adds four numbers (found in `RAM[0]`, ..., `RAM[3]` or `R0`, ..., `R3` equivalently) and stores result in `RAM[0]` (a.k.a. `R0`). Your program must finish in 30 cycles or fewer.
- `Max4` -- finds the largest value in `R0-R3` and stores result in `R0`. Your program must finish in 100 cycles or fewer.
- `Sort4` -- sorts (ascending) values in `R0-R3`. Your program must finish in 200 cycles or fewer.
- `Search` -- given a value to find in `R0` and a memory address in `R1` (>= 2) that indicates the last position in memory of the values to search through, search through `RAM[2]-RAM[n]` (where `n` is the value in `R1`) for the value `R0`. If the value is found, set `R0` to 1. Otherwise, set `R0` to 0. Your program must finish in 200 cycles or fewer.
- `MoveDot` -- initially sets the exact middle pixel of the screen (row 127, col 255) to black, and then on every key press (up/down/left/right), moves the dot one pixel in that direction; dot wraps around when it hits the edges. Note, sometimes the screen doesn't update properly in the simulator. If you suspect this is happening, restart the simulator.

[Download ZIP containing test scripts](/code/project-04.zip) -- NOTE: at the moment, there is no test script for `MoveDot`.

## Extra credit

If your programs are the shortest among other submissions from our class, you receive extra credit.

- All programs minimal: +2 pts
- At least 2 programs minimal: +1 pt
