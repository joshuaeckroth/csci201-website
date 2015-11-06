---
layout: post
title: Forth language
---

# Forth language

Install Gforth:

- Windows: [gforth.exe](http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.0.exe)
- Mac: [download a .pkg file](http://rudix.org/packages/gforth.html)
- Linux: you know the drill

## Overview

- For our purposes, **Forth code requires no variables.** Everything is on the stack. There is no need for `argument 0` or `temp 0` or whatever.
- Pushes and pops are **implicit**. There is no `push` command nor `pop` command.

## Syntax

```
( comment... requires a space after first left-paren )

( define a word with colon and semicolon )
: timesTwo 2 * ;

( everything else is either a number, which pushes to the stack, or a word )
5 2 + 3 * 10 - timesTwo
```

Words are often "documented" by indicating how the stack is transformed: `( n -- n n )` means `n` was on the top of the stack, and `n n` is now at the top of the stack (`n` is duplicated).

Interesting words:

```
.s ( show stack )
. ( pop off top of stack, show it )
clearstack
invert ( -1/0 -- 0/-1 // instead of "not" )
see [word] ( show definition of a word )
dup ( n -- n n )
2dup ( a b -- a b a b )
drop ( n -- )
swap ( a b -- b a )
over ( a b -- a b a )
2over ( a b c d -- a b c d a b )
rot ( a b c -- b c a )
2rot ( a b c d e f -- c d e f a b )
```

## Conditionals

A `-1` (true) or `0` (false) value should be at the top of the stack.

```
if [words to execute when if is true] else [alternative words] then
```

The `else` part is not required.

## Loops

A `do` loop expands at compile time, which is nice because you do not need to keep any values on the stack. The words inside the loop are repeated `num1-num2+1` times.

```
[num1] [num2] do [words to repeat] loop
```

Example follows. In this case, the words inside the loop are repeated five times.

```
5 1 do [words to repeat] loop
```

A more sophisticated loop is `begin/until`. In this case, the word just before `until` must return `-1` (true) or `0` (false) to indicate if the loop should stop. `-1` means stop, `0` means repeat. Because the code inside the loop can decide whether or not it repeats, this loop is maximally general. The `do/loop`, on the other hand, repeats a fixed number of times (determined by what's on the stack just before the loop starts).

```
begin [words to repeat] [-1/0 value, or word to produce that value] until
```


