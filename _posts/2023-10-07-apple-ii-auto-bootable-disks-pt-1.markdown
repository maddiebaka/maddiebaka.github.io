---
layout: single
title: Apple II Auto-Bootable Disks, Pt. 1
date: 2023-10-07T12:28:42-04:00
---

As someone who didn't grow up around 8-bit microcomputers, learning more about the Apple II has 
been quite the learning process. There are a lot of books around, a ton of them are on the
[internet archive](https://archive.org/). I've included links to some good starting resources in the
references section at the bottom of the page.

There are a couple ways to create a floppy disk that auto-executes something when the
computer is first powered on. This article will cover most simple procedure for BASIC, and a 
subsequent article will cover more advanced methods.

# Apple DOS

To start with, we're going to need to boot into [Apple DOS](https://en.wikipedia.org/wiki/Apple_DOS). 
There are disk images that you can [download](https://mirrors.apple2.org.za/ftp.apple.asimov.net/images/masters/).
I'm using DOS version 3.3, which is the best-known and most-used version of Apple DOS.

![Applesoft DOS 3.3 System Master](/assets/apple2/autoexec/1-boot-dos.png)

> If you have a disk that's been formatted for Apple DOS, it technically has a copy of DOS on that
> diskette. The DOS is just the disk input/output routines and commands that we'll be using. 

This emulator is equipped with two diskette drives; in these examples I'll be booting from drive 1,
and creating the bootable media in drive 2. Your syntax will differ slightly if you only have one 
diskette drive.

# Booting to a BASIC Program

Once we've booted to DOS, we'll create a new BASIC program.


```
] NEW
] 10 HOME
] 20 PRINT "MADDIE'S DISK"
] 30 END
```

If we were to type `RUN` at this point, we'll see the screen clear, `MADDIE'S DISK` print out
and then the BASIC program will exit.

We'll insert a blank diskette into Drive 2 (virtually, in this case), and execute:

```
] INIT HELLO,D2
```

This initializes the new diskette, creates a BASIC program called `HELLO` and sets up the information
on the disk so that it's flagged to be automatically executed on boot. Running `CATALOG` shows
the new file `HELLO`. The `A` alongside it stands for `APPLESOFT BASIC`, the type of file that it is.

![three](/assets/apple2/autoexec/3-init-disk.png)

The program that you typed into memory is automatically saved to this file.

> The `,D2` portion of the command instructs DOS to execute the command on the second disk drive.
> The system will remember the last drive used, and continue to use that drive until told otherwise.

## Testing the Diskette

Now, if you swap your new diskette into Drive 1, and reboot the system, you should see 
`MADDIE'S DISK` (or whatever you typed) at the top of the screen, followed by a `]` BASIC prompt.

![BASIC program runs on boot](/assets/apple2/autoexec/4-autoexec-basic.png)

You can store any kind of BASIC program you'd like in `HELLO`, and update it, using the `LOAD` and
`SAVE` commands. Pressing the `RESET` key will also drop you to a BASIC prompt.

`INIT` has also installed a copy of Apple DOS to this diskette. You'll be missing other files that
are on the Master Disk, but this floppy is now bootable and contains commands such as `INIT` and
`CATALOG` for disk operation.

# References

[Apple II Reference Manual](https://archive.org/details/applerefjan78/page/n1/mode/2up)

[Apple II BASIC Programming Manual](https://archive.org/details/apple-ii-basic-programming)

[Apple Computer Manuals Collection](https://archive.org/details/manuals-apple)

