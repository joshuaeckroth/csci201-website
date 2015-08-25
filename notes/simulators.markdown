---
layout: post
title: Simulators
---

# Simulators

Download: [csci201-simulators-v2.6.zip](/csci201-simulators-v2.6.zip)

This package consists of three graphical simulators:

- **Hardware simulator**: works with HDL files and test scripts. Used for project 1, among others.
- **CPU emulator** (not technically a simulator): runs machine code (Hack) or ASM code.
- **VM emulator** (not technically a simulator): runs VM code.

## Installation

No "installation" is required. Just unzip the package.

## Hardware simulator

Run the hardware simulator with this command (Windows):

```
HardwareSimulator.bat
```

Or this command (Mac, Linux):

```
./HardwareSimulator.sh
```

### Example 1: Debug an HDL file

Suppose you were tasked with writing an HDL file that implements the OR gate in terms of AND and NOT. Here is the correct HDL file:

```
/**
 * Or gate:
 * out = 1 if (a == 1 or b == 1)
 *       0 otherwise
 */

/* This version uses only AND and NOT gates. */

CHIP Or {
    IN a, b;
    OUT out;

    PARTS:
    Not(in=a, out=nota);
    Not(in=b, out=notb);
    And(a=nota, b=notb, out=and);
    Not(in=and, out=out);
}
```

Load this HDL file with the "chip" icon:

![HW Sim](/images/hw-sim-1.png)

Then play around with different input values and hit the ">" icon to evaluate your chip:

![HW Sim](/images/hw-sim-2.png)

### Example 2: Test an HDL file

You'll want to test your chip with the `.tst` scripts I provide. You should have your HDL file and my `.cmp` file in the same folder as the `.tst` script.

Load the test script with the "scroll" icon:

![HW Sim](/images/hw-sim-3.png)

Then run all test cases with the ">>" icon. If a test fails, the status bar (at the bottom) will tell you which test failed.

![HW Sim](/images/hw-sim-4.png)

You can also view the desired output by selecting "Compare" from the "View" menu (shown below). Use the same drop-down menu to view your chip's output by selecting "Output" from the menu.

![HW Sim](/images/hw-sim-5.png)


