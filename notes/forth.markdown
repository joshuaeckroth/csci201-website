---
layout: post
title: Forth language
---

# Forth language

Install Gforth:

- Windows: [gforth.exe](http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.0.exe)
- Mac: [download a .pkg file](http://rudix.org/packages/gforth.html)
- Linux: you know the drill

## Syntax

```
( comment... requires a space after first left-paren )

( define a word with colon and semicolon )
: timesTwo 2 * ;

( everything else is either a number, which pushes to the stack, or a word )
5 2 + 3 * - timesTwo
```

Words are often "documented" by indicating how the stack is transformed: `( n -- n n )` means `n` was on the top of the stack, and `n n` is now at the top of the stack (`n` is duplicated).

Interesting words:

```
.s ( show stack )
. ( pop off top of stack, show it )
dup ( n -- n n )
drop ( n -- )
```

## Conditionals

A `-1` (true) or `0` (false) value should be at the top of the stack.

```
if [words to execute when if is true] else [alternative words] then
```

The `else` part is not required.

## Loops

```
[num] [num] do [words to repeat] loop
```

```
begin [words to repeat] [-1/0 value, or word to produce that value] until
```


