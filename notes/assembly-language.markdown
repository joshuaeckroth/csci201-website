---
layout: post
title: Assembly language
---

# Assembly language

In the book, this language is known as "Hack".

[Cheatsheet (PDF)](/hack-asm-cheatsheet.pdf)

## Elements of a computer

- CPU
- Registers
- Memory
	- RAM
	- ROM
	- 16-bit values, an address refers to a certain 16-bit value
	- 15-bit address space (32K)
		- you’ll see why: need 1 bit to indicate we’re going to store a value (which will be an address), so 15 bits left over for that actual value
- Commands
	- load/store to/from registers & memory
	- add, subtract, and, or, etc.
	- eventually, multiply, divide, etc. (will implement later)
- Simplest possible language (simple in implementation): 16-bit strings

## Linear programming vs. structured programming

- See: [my notes from CSCI 141](http://csci141.artifice.cc/lecture/proglang.html)

## Memory “addressing”

- Immediate addressing: load a constant value into register
- Direct addressing: load into register value from memory at a specific address
- Indirect addressing: use a pointer; look in memory at some direct address and load from memory at address stored in first memory location
	- In Hack, we have to do this in two steps
- A register is always used to store memory address; “M” in commands uses memory address in A

## Flow of control

- PC
- Jumps
	- conditional, non-conditional
	- jump address is always stored in A


## Instruction format in binary

- A instruction: 0vvv…vvv (15-bit value)
- C instruction: `1 1 1 a c1 c2 c3 c4 c5 c6 d1 d2 d3 j1 j2 j3`
	- second, third bits wasted
	- `a-c6`: computation to perform; see table on page 67
	- `d1-d3`: destination; see table on page 68
	- `j1-j3`: jump; see table on page 69

## Assembly language syntax

- Labels `(Foo)`
	- can be treated as values in `@Foo`
- Variables: `Abc` (as long as it’s not a label); will be set to an arbitrary memory address
	- They’re just numbers, to be used in A-instruction like this: `@Abc`
- All commands must be uppercase (e.g., `D=M` or whatever), but variables/labels can be mixed case, and it is case sensitive


