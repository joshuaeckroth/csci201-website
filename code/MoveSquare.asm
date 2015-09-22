
// move a 16x16 pixel square around the screen with the arrow keys;
// the pixels are defined by 16 16-bit words (one word per row)

// "variables":
// - x (x-location of top-left of square; range is 0-31)
// - y (y-location of top-left of square; range is 0-239)
// - pos (location of top-left of square, as a RAM index;
//        old value, set by the MAYBEDRAW code)
// - newpos (next value of pos; this is calculated by
//           the code in the top of MAYBEDRAW)
// - tmp (temporary variable for doing multiplications)
// - delay ("frames" to wait before checking for new key press)
// - wait (counts down from @delay, when 0, checks key and resets)

// set delay to 50000; lower this value if your computer is slow
@1000
D=A
@delay
M=D

// set wait to 0 (checks key when program starts)
@wait
M=0

// set x, y to 16, 125
// (center coordinates, more or less)
@16
D=A
@x
M=D
@125
D=A
@y
M=D
// set pos to 0, so it will not match calculated newpos,
// and drawing will happen first time around
@pos
M=0
@CLEARENTIRESCREEN
0;JMP

(MAYBECHECKKEY)
// figure out if we've waited long enough by checking if wait = 0
@wait
D=M
@CHECKKEY
D;JEQ
// nope, didn't wait long enough, decrement wait counter
@wait
M=M-1
@MAYBECHECKKEY
0;JMP

(CHECKKEY)
// reset wait counter
@delay
D=M
@wait
M=D
// check 'right' key press
@KBD
D=M
@132
D=D-A
@MOVERIGHT
D;JEQ
// check 'left' key press
@KBD
D=M
@130
D=D-A
@MOVELEFT
D;JEQ
// check 'up' key press
@KBD
D=M
@131
D=D-A
@MOVEUP
D;JEQ
// check 'down' key press
@KBD
D=M
@133
D=D-A
@MOVEDOWN
D;JEQ
// no recognized keypress; don't draw, just check keys again
@MAYBECHECKKEY
0;JMP

(MOVERIGHT)
// get cur x
@x
D=M
// increment x position by 1
MD=D+1
// if new column is off-screen on the right, reset to left side
@31
D=D-A
@MAYBEDRAW
D;JLE
// didn't jump, so must be off-screen on the right, so reset to 0
@x
M=0
@MAYBEDRAW
0;JMP

(MOVELEFT)
// get cur x
@x
D=M
// decrement x position by 1
MD=D-1
// if new column is off-screen on the left, reset to left side
@MAYBEDRAW
D;JGT
// didn't jump, so must be off-screen on the left, so reset to 31
@31
D=A
@x
M=D
@MAYBEDRAW
0;JMP

(MOVEUP)
// get cur y
@y
D=M
// decrement y position by 1
MD=D-1
// if new row is off-screen on the top, reset to bottom
@MAYBEDRAW
D;JGE
// didn't jump, so must be off-screen on the top, so reset to 239
@239
D=A
@y
M=D
@MAYBEDRAW
0;JMP

(MOVEDOWN)
// get cur y
@y
D=M
// increment y position by 1
MD=D+1
@239
D=D-A
// if new row is off-screen on the bottom, reset to top
@MAYBEDRAW
D;JLE
// didn't jump, so must be off-screen on the bottom, so reset to 0
@y
M=0
@MAYBEDRAW
0;JMP

(MAYBEDRAW)
// calc newpos = @SCREEN + y*32 + x
// (multiplication accomplished by addition)
@SCREEN
D=A
@newpos // start newpos at @SCREEN
M=D
@y
D=M
@ADDX // if y = 0, move on to adding x
D;JEQ
@tmp // save y (in reg D) into tmp, so we can decrement it
M=D
(ADDY)
@newpos
D=M
@32
D=D+A
@newpos
M=D
@tmp
MD=M-1
@ADDY
D;JGT
(ADDX)
@newpos
D=M
@x
D=D+M
@newpos
M=D
// check if we should clear & draw the screen
// we should do so only if pos != newpos
@pos
D=M
@newpos
D=D-M
@DRAW
D;JNE
@MAYBECHECKKEY
0;JMP

(DRAW)
// clear the old rectangle using pos (old value)
@pos
AD=M
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
AD=D+A
M=0
@32
// done clearing screen
// save newpos into pos
@newpos
D=M
@pos
M=D
// draw the square
@pos
AD=M
M=-1
// move down a row (add 512/16=32 columns)
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@32
AD=D+A
M=-1
@MAYBECHECKKEY
0;JMP

(CLEARENTIRESCREEN)
@SCREEN
D=A
(CLSCONTINUE)
A=D
M=0
D=D+1
@KBD
D=D-A
@MAYBEDRAW
D;JEQ
// add KBD back
@KBD
D=D+A
@CLSCONTINUE
0;JMP
