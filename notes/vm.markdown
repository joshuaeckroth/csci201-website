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
function File.funcname [argcount]
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

