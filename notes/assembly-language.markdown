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

## Examples

### Absolute value

```
// absolute value function

// suppose RAM[0] has a value, could
// be negative; overwrite RAM[0]
// with the absolute value version

@0
D=M
@Done
D;JGE
// didn't jump, so flip sign of neg value
@0
M=-D
(Done)
```

### Quotient

```
// quotient of RAM[0] / RAM[1]

// strategy: count how many times we can
// subtract RAM[0]-RAM[1] without going negative
// save counter in RAM[2]

@2
M=0   // start counter (RAM[2])
@0
D=M   // load RAM[0] into D
(Sub)
@1
D=D-M // D=D-RAM[1] (i.e., D=RAM[0]-RAM[1])
@Save
D;JLT // jump to Save label if D < 0 (RAM[0]-RAM[1]<0)
@2
M=M+1 // increment counter
@Sub
0;JMP // otherwise (else), jump back to top Sub label (subtract again)
(Save)
@2
D=M   // get counter value
@0
M=D   // save counter into RAM[0]
(End)
@End  // loop forever
0;JMP
```

### Modulo

```
// modulo; RAM[0] % RAM[1], store in RAM[0]

// repeatedly subtract RAM[1] from RAM[0],
// until RAM[0]-RAM[1] < 0


@0
D=M   // load RAM[0] into D
(Sub)
@1
D=D-M // D=D-RAM[1] (i.e., D=RAM[0]-RAM[1])
@Save
D;JLT // jump to Save label if D < 0 (RAM[0]-RAM[1]<0)
@Sub
0;JMP // otherwise (else), jump back to top Sub label (subtract again)
(Save)
@1
D=D+M // save operation involves saving D into RAM[0]
@0    // but we gotta add back RAM[1] because D<0 currently
M=D
(End)
@End  // loop forever
0;JMP
```

### Sum list

```
// sum a list

// RAM[0] will hold the sum (it holds meaningless data at first)
// RAM[1] says final position of values
// RAM[2] is start of values

@0
M=0

(NEXT)
@0
D=M
@1
A=M
D=D+M // add value at end of list
@0    // save back to RAM[0]
M=D

@1
MD=M-1
D=D-1
@DONE
D;JEQ
@NEXT
0;JMP

(DONE)
@DONE
0;JMP
```

## MIPS assembly language

The MIPS32 processor has the following features:

- 32-bit words (4-bytes per word)
- 32 registers (some have special purposes)
- RISC design (reduced instruction set computer)

RISC was a revolution in the 80's, and the MIPS chip was the first of its kind. A RISC chip differs from a CISC chip (complex instruction set computer) in that a RISC chip supports a small number of operations (read/write memory, ALU operations, jumps) and the operations are used in a very consistent way. For example, every ALU operation has exactly three arguments: the destination register and the two source registers. There are no ALU instructions that are capable of reading/writing memory. Data from memory can be loaded/stored into/out of registers and from/to memory using dedicated instructions. The idea is that if the instructions are very minimal and consistently designed, and more registers are available (32 instead of 10 or so in CISC chips at the time), then each instruction can be made very fast (due to its simplicity) and therefore the chip can be faster.

Intel chips are common examples of CISC chips (although modern Intel chips have RISC-like cores). There were some very complex CISC chips in the 80's, like the VAX chip, which included instructions like `movsb` (copy string; Intel chip) and `insque` (insert into queue; VAX chip). On a RISC chip, those kinds of instructions would require several individual instructions including jumps (for loops).

The assembly language used by our book is extremely simple, but not so pristine as RISC. We have instructions that read/write memory while also performing ALU operations, for example. So it's CISC-like in that way.

### MIPS registers

| Register ID | Register Name | Description |
| ----------- | ------------- | ----------- |
| `$0`        | `$zero`       | read-only, always has value 0 |
| `$1`        | `$at`         | "assembler temporary"; not available for use |
| `$2 - $3`   | `$v0 - $v1`   | "values", used for function return values |
| `$4 - $7`   | `$a0 - $a3`   | "arguments", used for function calls |
| `$8 - $15`  | `$t0 - $t7`   | "temporaries", **these are ones you'll use most** |
| `$16 - $23` | `$s0 - $s7`   | "saved values", used for function calls |
| `$24 - $25` | `$t8 - $t9`   | more temporary registers |
| `$26 - $27` | `$k0 - $k1`   | reserved |
| `$28`       | `$gp`         | "global pointer", points to data available for all functions |
| `$29`       | `$sp`         | "stack pointer", points to top of stack |
| `$30`       | `$fp`         | "frame pointer", points to base of stack for current function |
| `$31`       | `$ra`         | "return address", points to jump address for calling function |

You'll use registers `$t0` through `$t7`. Many of the other registers have special purposes related to function calls. (Yes, you can call functions in assembly language.) We'll talk about function calls later in the course.

### MIPS instructions

RISC chips can be tedious to program by-hand, since the instructions are so simple. Thus, there do exist some "psuedo" instructions that actually turn into several simple instructions when the assembly source code is translated to machine code.

Below, I list the instructions we care about. Note that anything with a `$` means "register", e.g., `$t0`.

#### ALU instructions

| Instruction | English name | Meaning |
| ----------- | ------------ | ------- |
| `add $a, $b, $c` | Add | `$a = $b + $c` |
| `addi $a, $b, N` | Add immediate | `$a = $b + N` (`N` is a number) |
| `sub $a, $b, $c` | Subtract | `$a = $b - $c`; to subtract a particular value like `N`, use `addi $a, $b, -N` |
| `mul $a, $b, $c` | Multiply | `$a = $b * $c`; note, only first 32-bits of result are saved (multiply of two 32-bit values can result in a 64-bit value; don't multiply big numbers this way) |
| `div $a, $b, $c` | Divide (quotient) | `$a = $b / $c` |
| `rem $a, $b, $c` | Remainder (modulo) | `$a = $b % $c` |
| `and $a, $b, $c` | Bit-wise And | `$a = $b & $c` |
| `or $a, $b, $c` | Bit-wise Or | `$a = $b | $c` |
| `xor $a, $b, $c` | Bit-wise Xor | `$a = $b ^ $c` |
| `nor $a, $b, $c` | Bit-wise Nor | `$a = ~($b | $c)` |
| `slt $a, $b, $c` | Set-on-less-than | `$a = ($b < $c)` |
| `slti $a, $b, N` | Set-on-less-than-immediate | `$a = ($b < N)` |
| `move $a, $b` | Move (copy) register | `$a = $b` |
| `clear $a` | Clear (erase) register | `$a = 0` |

#### Memory instructions

| Instruction | English name | Meaning |
| ----------- | ------------ | ------- |
| `lw $a, N($b)` | Load word | Load 32-bit value into register `$a` from memory location computed as `$b + N`; often, `N=0`, and can be omitted: `lw $a, ($b)` |
| `la $a, label` | Load address of a label | `$a = label`, where label is some label in code or `.data` section (see below) |
| `li $a, N` | Load immediate value | `$a = N`, where `N` is just a number, like 52 |
| `sw $a, N($b)` | Store word | Store 32-bit value from register `$a` into memory location computed as `$b + N`; often, `N=0`, and can be omitted: `sw $a, ($b)` |

#### Jump instructions

In most processors, including MIPS, there are two kinds of jumps: those known as jumps, and those known as "branches." When both terms are used, jumps are always unconditional, while branches are always conditional.

When a number `N` is used below, that number can be an actual integer (e.g., 52) or, more likely, the name of a label from your code.

| Instruction | English name | Meaning |
| ----------- | ------------ | ------- |
| `jr $a`     | Jump register | Jumps to address in `$a` |
| `j N`       | Jump          | Jumps to address `N` (often `N` is a label) |
| `beq $a, $b, N` | Branch on equal | Jumps to `N` if `$a = $b` |
| `bne $a, $b, N` | Branch on not-equal | Jumps to `N` if `$a != $b` |
| `blt $a, $b, N` | Branch on less-than | Jumps to `N` if `$a < $b` |
| `ble $a, $b, N` | Branch on less-than-or-equal | Jumps to `N` if `$a <= $b` |
| `bgt $a, $b, N` | Branch on greater-than | Jumps to `N` if `$a > $b` |
| `bge $a, $b, N` | Branch on greater-than-or-equal | Jumps to `N` if `$a >= $b` |

#### Data and RAM

Unlike the assembly language from our textbook, a MIPS chip does not have separate ROM and RAM sections of memory. Instead, in each program, you declare (at the top) what your RAM memory will be (indicated by `.data`), and your program code will automatically occupy ROM (indicated by `.text`).

You can label the different parts of your program's RAM. Here is an example:

```
.data
count: .word 20  # make 'count' a variable (32-bits, 1 word) with initial value 20
vals:  .word 8, -2, 3, 7, 2 # make 'vals' an array of 5 words, with initial values given
```

To access these values, use `lw` on regular values (not arrays), and `la` on arrays:

```
lw $t0, count    # load value of 'count' (20) into $t0
la $t1, vals     # load address of start of array 'vals' into $t1
lw $t2, ($t1)    # load first element in array 'vals' (8) into $t2
lw $t2, 4($t1)   # load second element (4-bytes beyond first address)
lw $t2, 8($t1)   # load third element (4-bytes beyond first address)
```

You can also iterate through an array but using another register as the address, and always adding 4 to it to get the next address:

```
la $t1, vals
lw $t2, ($t1)     # load first value
addi $t1, $t1, 4  # generate next address
lw $t2, ($t1)     # load second value
addi $t1, $t1, 4  # generate next address
...etc...
```

In order to save values back into variables, load the address first and then store the value:

```
la $t0, count     # get address of count variable
sw $t4, ($t0)     # save value in $t4 to count variable (using its address)
```

### Template of a MIPS assembly language program

```
.data
# sepecification of program's RAM data...

.text
.globl main

main:             # this label is required; your program starts here

       ...code...

       jr $ra     # always need this at the end; it terminates your program
```

### SPIM simulator

Download the [QtSpim MIPS Simulator](http://sourceforge.net/projects/spimsimulator/files/). The tool's main page is [here](http://spimsimulator.sourceforge.net/).

In the following example, I load and run this (pointless) program:

```
.data
        count:  .word 52
        vals:   .word 1, 2, 3, 4, 5
.text
.globl main

main:
        lw $t6, count
        addi $t0, $zero, 3       # a = 3
        addi $t1, $zero, 2       # b = 2
        add $t2, $t0, $t1        # c = a + b

        jr $ra                   # terminate
```

Steps:

1. Start up QtSpim
2. Load your program with the second-button-from-the-left (folder with a blue icon inside it).
3. Look at Data tab and Text tab to examine your loaded program.
4. Run single-step through your program using icon that looks like a bulleted list (right-of the stop icon). Watch your registers on the left panel.
5. Check your results in the data tab.

![QtSpim loading program](/images/qtspim-1.png)

![QtSpim looking at code](/images/qtspim-2.png)

![QtSpim looking at data](/images/qtspim-3.png)

![QtSpim single-stepping code](/images/qtspim-4.png)
