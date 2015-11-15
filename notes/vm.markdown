---
layout: post
title: Virtual machine language
---

# Virtual machine language

## Data storage

```
push/pop temp [0-7]   // temporary variables
push argument [0-n]   // arguments given to function (lost when function returns)
push/pop static [0-n] // global variables
```

Don't use "local" variables (`pop local 0` or whatever); we won't be able to correctly utilize local variables until we write a translator from yet another higher-level language.

## Functions

Defining a function:

```
function File.funcname [local count]
...
return // whatever's on the top of the stack is the return value
```

Calling a function:

```
// push values to correspond to func arguments
push constant 55 // or push temp 0 or ... (don't use "local")
push constant 10
call Foo.bar 2 // 2-argument function
// return value is on top of stack
pop temp 0 // save return value somewhere (if needed)
```

## Pointers

Two special memory locations are called `this` and `that` (RAM[3] and RAM[4], respectively). Should a value be put in `this` or `that`, you can thereafter use that value as the memory location of another value. If you are familiar with "pointers" (from C/C++), `this` and `that` are pointers.

You put values into `this` and `that` by using `pop pointer 0` and `pop pointer 1` (respectively).

Example:

```
// ultimately, we want to save into RAM[999];
// we'll use "this" as a pointer
push constant 999
pop pointer 0     // save 999 into "this"
push constant 37
pop this 0        // save 37 into RAM[999]; "this 0" means 999+0
```

## Arrays

You can use `pop this [n]` or `push this [n]` (alternatively `that`) to put values into an array at position `n`. The start of the array should be a memory address stored in `pointer` position 0 (`pop pointer 0`) if you use `this`, or `pointer` position 1 if you use `that`. You can also iteratively increase the value in `pointer` in order to walk through an array.

```
// local var A is an array; its value is technically the location
// in memory where the array starts

push local 0     // push A (location of start of array) onto stack
pop pointer 0    // move that value into pointer 0 (used for "this")

push constant 55 // arbitrary value to store in array
pop this 0       // set A[0] = 55

push constant 19 // another arbitrary value
pop this 8       // set A[8] = 19
```

## Translation to Assembly

Naturally, VM code must be translated to assembly (which must be translated to machine code) before VM code can execute. This section gives details about that translation.

In assembly coding, all of RAM was free to use. With the virtual machine, RAM is divided into these segments:

| RAM Addresses | Usage |
|---------------|-------|
| 0 | Stack pointer (`@SP`)
| 1 | Start of current function's `local` segment (`@LCL`) |
| 2 | Start of current function's `argument` segment (`@ARG`) |
| 3 | Start of current function's `this` segment in heap (`@THIS`) |
| 4 | Start of current function's `that` segment in heap (`@THAT`) |
| 5-12 | Holds contents of `temp` segment (`temp 0` is `RAM[5]`, etc.) |
| 13-15 | Can be used as registers by VM |
| 16-255 | Static variables |
| 256-2047 | Stack |
| 2048-16383 | Heap |
| 16384-24575 | Memory mapped I/O (screen, keyboard) |
| 24575-32767 | Unused |

Most RAM manipulations take place in the stack segment, though there are some special cases where the VM-assembly translator must deal with the other segments.

### Arithmetic

The simplest VM code is just arithmetic operations, e.g.,

```
push constant 7
push constant 8
add
```

The VM-assembly translator must translate that code into the following abstract operations:

1. Save a `7` into `RAM[SP]` (whatever `SP` points to, save `7` there). Then increase the value of `SP`. That is effectively pushing 7 onto the stack.
2. Push `8` onto the stack in the same manner.
3. Pull the value at the top of the stack (the 8) into a register (say, `D` register). Decrement the stack pointer `SP`. Add the 8 with the new value at the top of the stack (the 7) and save the result back into the same place (overwriting the 7 at the top of the stack).

You can treat each line as an independent operation. `push constant 7` will always do the same thing, regardless of what came before or next. `add` always does the same thing, etc.

### Function definitions

When the VM code contains the start of a function, e.g.,

```
function Foo.bar 5
```

(where 5 represents the number of locals used in the function), the VM-assembly translator should do the following:

1. Create a label representing the function name. This is where the function officially starts.
2. When the function is called, the `LCL` pointer equals the stack pointer `SP`. This leaves no room for local variables; recall that local variables are stored just before the stack starts. So, the stack pointer must be moved forward by the number of locals (5 in the example). You should also set those local values to 0 (so effectively push constant 0 num-locals times, or 5 times in this example).

### Function calls

```
call Foo.bar 2
```

where 2 is the number of function arguments. For a diagram, see slide 17 of [the book authors' slides](http://www.nand2tetris.org/lectures/PDF/lecture%2008%20virtual%20machine%20II.pdf).

1. Create a unique label name for the line of code *after* the function call. This is where the function's `return` statement needs to jump to continue execution of the calling function.
2. Push the return address (identified by the unique label generated in step 1) onto the stack.
3. Push each of these values from memory onto the stack, in this order, so they can be restored after the function has been called: `LCL`, `ARG`, `THIS`, `THAT`.
4. Set memory `LCL` to the current value of the stack pointer. The function's local variables start in memory at the start of the current stack.
5. Set `ARG` value in memory to current `SP` value minus number of args (2 in the example) minus 5. This needs to be done after old value of `ARG` was pushed on the stack (step 5). We subtract 5 from `SP-argcount` because we want `ARG` to point to the last values put on the stack before the function call, and those values live exactly at `SP-argcount-5` because we have pushed five values onto the stack (return address, `LCL`, `ARG`, `THIS`, `THAT`).
6. Finally, jump to the function's address, which is held in the variable `Foo.bar` (whatever the function name); this variable was established earlier (see "function definitions" section above).

### Returning from a function call

```
return
```

The steps below undo all the pushes that were performed when the function was called (see section above, "function calls"). For a diagram, see slide 17 of [the book authors' slides](http://www.nand2tetris.org/lectures/PDF/lecture%2008%20virtual%20machine%20II.pdf).

Note, the return value from the function is on the top of the stack, currently. Also note that `ARG` points to the location in memory with the first argument from the original function call that is being returned from, so `ARG+1` will be the final stack pointer after returning (`ARG+1` because we'll leave the return value on the stack).

1. Pop the return value off the top of the stack and save somewhere temporarily, e.g., `R13`.
2. Save `ARG` value in memory to a temporary holding place, e.g., `R14`. We'll need this later to figure out where the stack pointer was before the function was called.
2. Restore each of these values back into memory, in reverse order that they were pushed: `THAT`, `THIS`, `ARG`, `LCL`.
3. Now, the next value on the stack is the return address; pop this off into, say, `R15`.
4. Set memory at the addressed saved in `R14` to the return value, since `R14` holds the new top of the stack. Then set the new stack pointer `SP` to `R14+1`. After this is done, according to the parent function's perspective, the stack looks just like it left it before the function call (and before pushing the function arguments), except that the function's return value is also on the stack.
5. Jump to the address stored in `R15`, which was the location of the next line of code in the calling function.
