---
layout: post
title: Project 3
due: "Sep 16, 11:59pm"
categories: [projects]
---

# Project 3

- **Read Chapter 3 and Appendix A.**
  - Here are some free chapters: [http://www.nand2tetris.org/chapters/](http://www.nand2tetris.org/chapters/)

- Create a repository on Bitbucket named exactly `csci201-project-03`. Invite me (`joshuaeckroth`) as a reader.

Implement the following chips by writing an HDL file for each. Start with the HDL templates provided. Be sure to test your implementations with the corresponding test scripts.

You may use any chip described in Chapters 1 and 2, and any other chips you build.

## Chips to implement

- `Bit`
- `Register`
- `PC`
- `ClockGen` (my creation, not in the book)
- `RAM4` (my creation, not in the book)
- `RAM8`
- `RAM16K` (you are free to use `RAM4K`, `RAM512`, `RAM64`, `RAM8`, and/or `RAM4` for this)

The `RAM16K` chip is in a separate folder, to be sure the simulator does not load `RAM8` and other RAM chips that will slow down the simulator. You want the simulator to use builtin (Java-coded) chips for the various RAM chips used by `RAM16K`.

[Download a ZIP file containing the necessary files](/code/project-03.zip).

## Restrictions

For your chips to be considered correct, you must meet the following restrictions:

- The `Bit` chip must NOT use a `Mux`.
- The `PC` chip must NOT use `Inc16`, rather, it must use the `ALU`.

## Grading

A chip is considered correct if it passes all of the tests defined in its corresponding `.tst` script and `.cmp` comparison output.

- All chips correct: 5 pts
- 5 or more chips correct: 4 pts
- 4 or more chips correct: 3 pts
- 3 or more chips correct: 2 pts
- 1 or more chips correct: 1 pt
- No chips correct: 0 pts

## Extra credit

If you implement your chips with the fewest chips/gates possible (fewest "PARTS" in the HDL file), you receive extra credit.

- All chips minimal: +2 pts
- At least 4 chips minimal: +1 pt


