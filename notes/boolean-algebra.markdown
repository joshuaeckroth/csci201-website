---
layout: post
title: Boolean algebra
---

# Boolean algebra

The following equivalences will aid you in project 1.

Syntax: a, b, c, ... are binary inputs. + means OR. * means AND. ~ means NOT.

## Identities

- a*a = a
- a*(~a) = 0
- a+a = a
- a+(~a) = 1
- a+(a*b) = a
- a*(a+b) = a

## De Morgan's laws

- Rule 1: ~(a+b) = ~a * ~b

- Rule 2: ~(a*b) = ~a + ~b

So, you also have:

- a+b = ~(~a * ~b)
- a*b = ~(~a + ~b)

