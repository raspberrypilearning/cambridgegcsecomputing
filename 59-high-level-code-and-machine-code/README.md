High level code and machine code
=============
A practical exercise to support episode 59 of the Cambridge GCSE Computing MOOC.

![image](./images/cover.jpg "Cover Image")

##Introduction

This exercise is intended to be done on a Raspberry Pi.  The intention is to create three programs.  One using assembly, one with the GCC compiler for C and finally one with interpreted Python.  The main goal is to reinforce the understanding of the three types of source code translators and to demonstrate the difference between compiled and interpreted code.

## Step 1: Setting Up your Pi
First check that you have all the parts you need to get your Raspberry Pi set up and working.

- Raspberry Pi
- Micro USB power adapter
- An SD Card with Raspbian already set up through NOOBS
- USB Keyboard
- HDMI cable
- A Monitor or TV

**Activity Checklist**

1.	Place the SD card into the slot of your Raspberry Pi. It will only fit one way so be careful not to break the card. 
2.	Next connect the HDMI cable from the monitor (or TV) to the HDMI port on the Pi and turn on your monitor. 
3.	Plug a USB keyboard into a USB slot on the Pi.
4.	Plug in the micro USB power supply and you should see some text appear on your screen.
5.	When prompted to login type:

	```
	Login: pi
	Password: raspberry
	```

##Step 2: Assemblers

The program here is just going to add two numbers together and then halt, exactly the same as what was done with the Little Man Computer simulator but for real on a Raspberry Pi CPU.  Firstly create a blank text file named `asm.s`.

`nano asm.s`

Enter the Arm assembly code below, or copy and paste it.  The text within the `/* */` blocks are comments and do not necessarily need to be entered.

```asm
.global main
.func main
main:
	mov r1, #3 /* set r1 to 3 */
	mov r2, #4 /* set r2 to 4 */
	add r0, r1, r2 /* set r0 to the sum of r1 + r2 */
	bx lr /* halt */
```

Press `Ctrl - O` to save and `Ctrl - X` to quit.

In this program we use three registers; R0, R1 and R2.  We set R1 to 3 and R2 to 4, we the add contents of R1 and R2 together and place the result in R0.  Note the use of the mnemonics mov, add and bx lr.  The last line halts the program.  The code can be assembled using the following Linux command.

`as -o asm.o asm.s`

This produces a file called `asm.o` which then needs to be packaged into an executable file using the GCC compiler.  The following Linux commands can be used to create the executable and run it.

```
gcc -o asm.bin asm.o
./asm.bin
```

It will be noticed that the program has no output and just returns to the command prompt.  This is because we have not entered the assembly code to print the answer to the screen.  To do this requires many more lines of code to be entered and would take a long time to program.  This could be attempted depending on available time.  However, it should be noted that a high level language can provide all of that work in a single line of code.

It is also worth it to look at the raw machine code of the program so the students can see that their assembly low level code was translated into binary machine code.  The `hexdump` Linux command will display the executable file in raw hexadecimal, which is slightly better to look at than raw binary.

`hexdump asm.bin`

This will obviously be completely unintelligible to humans, but reinforces the point that the code has been translated from a human readable form to a machine readable one.  It may also be worth showing that the executable file `asm.bin` can be distributed and copied to another Raspberry Pi where it will successfully run without the need to be compiled again.

##Step 3: Compilers

This C program will count from 1 to 10 and print out each number on a separate line on the screen.  To demonstrate the compiler behavior of checking every line of the program for syntax errors, before translating it into machine code, we will deliberately add a fake command that the compiler will not be able to understand.

This command will be `wibble`.  First create a blank C program named `comp.c`.

`nano comp.c`

Enter the C code below, or copy and paste it.

```c
#include <stdio.h>
main()
{
	int i;
	for (i = 1; i <= 10; i++)
	{
		printf("%d\n", i);
	}
	wibble
}
```

Press `Ctrl - O` to save and `Ctrl - X` to quit.

In this program we declare a variable called `i`, we then use a looping command to loop 10 times.  Each time around the loop `i` is increased by 1 and we print it to the screen.  After the loop is complete we have our fake command `wibble` which should cause an error to occur.

Use the following command to attempt to compile the program using the GCC compiler tool.

`gcc comp.c -o comp.bin`

An error similar to the following should be displayed and the file `comp.bin` should not be created.

```
comp.c: In function "main":
comp.c:10:5: error: "wibble" undeclared (first use in this function)
comp.c:10:5: note: each undeclared identifier is reported only once for each function it appears in
comp.c:11:1: error: expected ";" before "}" token
```

The compiler error is telling us exactly what line the problem occurs on.  The text `comp.c:10:5` means inside `comp.c` line 10 character 5.  We must now go and fix the problem and try and compile the code again.  

`nano comp.c`

Remove the `wibble` command from the code and run the GCC command above to recompile the code.  Once that has been done the compiled machine code `comp.bin` can be executed by entering the command below.

`./comp.bin`

The numbers 1 to 10 should now appear.  We can also view the machine code of this program using the following command.

`hexdump comp.bin`

Completely unintelligible once again but proves that our code was compiled into machine code from a high level human readable source language.  Again we can also copy the file to another Raspberry Pi and execute if it seems necessary.

##Step 4: Interpreters

We will now use Python, which is an interpreted language, to do exactly the same exercise again.  This will demonstrate that part of the program code will run up until the fake `wibble` command is encountered.  It will then cause the program to abort with an error.

First create a blank Python file.

`nano interp.py`

Enter the Python code below, or copy and paste it.

```python
#!/usr/bin/python
for i in range(1,11):
	print i
wibble
```

Press `Ctrl - O` to save and `Ctrl - X` to quit.

In this program we're also looping 10 times and printing the variable `i` to the screen each time round the loop.  The fake `wibble` command again occurs after the loop.

Since we don't actually compile Python code into a binary file of machine code we use the source code file itself as the executable file.  Use the following Linux commands to first mark the source code file as executable and then run it.

```
chmod +x interp.py
./interp.py
```

The result should be that some numbers are displayed before the error is encountered, the error should be as follows.

```
Traceback (most recent call last):
	File "./interp.py", line 5, in <module>
		wibble
NameError: name 'wibble' is not defined
```

So we can observe that part of the high level code did run.  This is because of the line by line nature of how the human readable source code is translated into machine code.  The execution has to wait until it reaches the fake command before it detects the problem.

Edit `interp.py` now and fix the problem.  

`nano interp.py`

Execute the program again and you should find that it completes without error.

`./interp.py`

There is no binary file to look at with hexdump this time, since the code that gets translated into machine code is never saved to disk.  It is just executed immediately and then is discarded once the program ends.
