## history
The history of teletypes finds its roots in initial experimentation during the
late 1800s, but truly began in the 1920s approaching an end in the 70s when fax
technology began to be good enough to replace them.

A teletype is basically a machine that sends letters you typed on the keyboard
through electric signals to another machine or network, and prints
(literally prints, on paper!) letters received through the reception cable.
Obviously, the different models evolved with time to offer more features and
performance possibilites.

The teletype was the perfect candidate as an input/output device. It was, after
all, a device designed to allow messages to be typed, encoded, sent, received,
decoded, and printed.

The terminal displays the characters that it receives on one of the wires
(some of those are control characters and make it do things like move the cursor,
change colour...) and sends on another wire the characters corresponding to the
keys you type.

Other than that, there is little intelligence in the terminal/terminal emulator.

## components

### Linux console (tty and tty driver - when not using Wayland/X11)
There are three different types of tty drivers: console, serial port, and pty.
Serial port is not viewed here

your current Linux machine keeps emulating several (usually 7 by default)
terminals connected to your hardware. But to protect you from the effort of
getting up and physically going to another chair, the OS allows you to switch
from one terminal to another by a simple press of keys (Ctrl+Alt+F1 to Ctrl+Alt+F7).
This feature is called virtual terminals, and is represented by the files /dev/tty1 to /dev/tty7.

If you write to it, you send the information to be printed to the terminal.
If you read from it, you receive what is typed from the terminal.

#### tty driver
A tty driver is a STREAMS driver managing the actual connection to the hardware
terminal. The pseudo-terminal (pty) driver is provided to support terminals that
need special processing, such as X terminals or remote systems connected through
a network.

A pty driver just transmits the input and output data from the application to a
server process through a second stream. The server process, running in the user
space, is usually a daemon, such as the rlogind daemon or the xdm daemon.
It manages the actual communication with the terminal.

The tty driver (core) is responsible for controlling both the flow of data across
a tty device and the format of the data. This allows tty drivers to focus on
handling the data to and from the hardware, instead of worrying about how to
control the interaction with user space in a consistent way. To control the flow
of data, there are a number of different line disciplines that can be virtually
“plugged” into any tty device.

the tty core takes data from a user that is to be sent to a tty device.
It then passes it to a tty line discipline driver, which then passes it to the
tty driver. The tty driver converts the data into a format that can be sent to
the hardware. Data being received from the tty hardware flows back up through
the tty driver, into the tty line discipline driver, and into the tty core,
where it can be retrieved by a user.

The driver’s job is to format data that is sent to it in a manner that the
hardware can understand, and receive data from the hardware. The tty line
discipline’s job is to format the data received from a user, or the hardware,
in a specific manner.

The user probably wants to run several programs simultaneously, and interact
with them one at a time. If a program goes into an endless loop, the user may
want to kill it or suspend it. Programs that are started in the background
should be able to execute until they try to write to the terminal, at which
point they should be suspended. Likewise, user input should be directed to the
foreground program only. The operating system implements these features in the
TTY driver

### Pseudo-terminal - pty (Konsole, Xterm, etc.)
In Linux, there is a *pseudo-teletype multiplexor* which handles the connections
from all of the terminal window pseudo-teletypes (PTS). The multiplexor is the
master, and the PTS are the slaves. The multiplexor is addressed by the kernel
through the device file located at /dev/ptmx.

when you launch a terminal within a graphic environment, it will spawn its own
equivalent of /dev/ttyX: the terminal emulator will open a special file located
in /dev/ptmx, called the master side of the pts, will work some magic with *ioctl*
function, which will create a slave side of the pts in /dev/pts/X (equivalent of tty driver)

The processes running in the session will be attached to this file, that will
behave like any file from the virtual terminal. You can open several terminal
emulator windows at the same time and display them side by side, having
different sessions running in parallel.

1. Gnome-terminal renders its UI on the video display.
1. It requests a PTY from the OS.
1. It launches a zsh subprocess.
1. It sets the stdin, stdout, and stderr of zsh to PTY slave.
1. It listens for keystroke events and sends the characters to PTY master.

*man pts says:*
The file /dev/ptmx is a character file with major number 5 and minor number 2,
usually of mode 0666 and owner.group of root.root. It is used to create a
pseudo-terminal master and slave pair.

When a process opens /dev/ptmx, it gets a file descriptor for a pseudo- terminal
master (PTM), and a pseudo-terminal slave (PTS) device is created in the /dev/pts
directory. Each file descriptor obtained by opening /dev/ptmx is an independent
PTM with its own associated PTS, whose path can be found by passing the descriptor
to ptsname(3).

Terminal emulators like xterm, instead of sending and receiving characters on wires,
they read and write characters on their file descriptor to the master side.
Once they've spawned the slave terminal, and started your shell on that, they
no longer touch that. In addition to emulating the pair of wire, xterm can also
change some of the line discipline properties via that file descriptor to the master side.

### line discipline
In a Unix-like system everything is a file, we all have heard this before.
A program managing a pty will essentially perform read and write operations on
a pair of files, pty master and pty slave. When a program calls the read or
write operations, behind the scene, the kernel will use the right implementation for us.
In the case of the pty, the kernel will use the tty driver to handle the
communication between the terminal and the program. The line discipline is a
logical component of the tty driver.

Most users make mistakes while typing, so a backspace key is often useful. So
as a convenience, the operating system provides an editing buffer and some
rudimentary editing commands (backspace, erase word, clear line, reprint),
which are enabled by default inside the *line discipline*. Advanced applications
may disable these features by putting the line discipline in raw mode instead
of the default cooked (or canonical) mode.

The line discipline is in charge of converting special characters (like end of
line, backspaces), and echoing what has been received back to the teletype, so
that the user can see what it has been typed

A lot of the intelligence is in the tty line discipline. The line discipline is
a software module (residing in the driver, in the kernel) pushed on top of a
serial/pty device file that sits between that device file that processes
interact with and the line/wire (the master side for a pty).

The line discipline is where **the terminal device internal line editor is implemented**.
For instance with *stty icanon echo* (as is the default), when you type a,
xterm writes a to the master, then the line discipline echoes it back
(makes a a available for reading by xterm for display), but does not make
anything available for reading on the slave side.

Then if you type backspace, xterm sends a ^? or ^H character, the line discipline
(as that ^? or ^H corresponds to the erase line discipline setting) sends back
on the master a ^H, space and ^H for xterm to erase the a you've just typed on
its screen and still doesn't send anything to the application reading from the
slave side, it just updates its internal line editor buffer to remove that a
you've typed before.

note that the bash prompt or other interactive applications like vi set the
terminal in the exact mode they need, so you want to use a dumb application
like cat to experiment with that. Many interactive terminal applications
disable most of the features of that line discipline to implement it themselves.
But in any case, beware that the terminal (xterm) has little involvement in
that (except displaying what it's told to display).

The tty line discipline is the default line discipline at least on Linux for

serial and pty devices. On Linux, you can change the line discipline with ldattach.
You can see the effect of disabling the tty line discipline by issuing
*stty raw -echo* . Then, everything that is written to the slave terminal device
makes it immediately to the master side for xterm to read, and every character
written by xterm to the master side is immediately available for reading from
the slave device.

As to what information is stored by a terminal device with a tty discipline
(serial or pty), that's typically what the *stty* command displays and modifies.

## processes

A session is a group of processes running under control of a single user.
Only a single session is active on a system (more precisely on a seat) and a user
can only interact with the active (or foreground) session. A session can start
and stop processes, but it cannot escape from the session. In other words, all
started processes will always belong to the session they were started in.

there can be only one session per process and per terminal device. A session can
have a controlling terminal attached to it but does not have to
(all sessions start without a terminal until they open one). xterm, in the
process that it forks to execute your shell will typically create a new session
(and therefore detach from the terminal where you launched xterm from if any),
open the new /dev/pts/x it has spawned, by that attaching that terminal device
to the new session. It will then execute your shell in that process, so your
shell will become the session leader. Your shell or any interactive shell in
that session will typically juggle with process groups and tcsetpgrp(), to set
the foreground and background jobs for that terminal.

The line discipline is also responsible for sending the SIGINT signal to the
foreground process group of the terminal when it receives a ^C character on the
master side.

The line discipline has been configured to intercept this character (^Z is a
single byte, with ASCII code 26), you don't have to wait for the editor to
complete its task and start reading from the TTY device. Instead, the line
discipline subsystem instantly sends SIGTSTP to the foreground process group.

what happens when you run a command on a terminal emulator?

1. PTY master receives characters from gnome-terminal and passes them to the line discipline layer.
1. Line discipline layer buffers the characters as you type them, writing back to PTY master so that you can see what you’re keying in.
1. When you press enter, the line discipline layer sends the characters to the TTY driver, which then passes the characters to the PTY slave.
1. zsh reads the characters “htop” and forks the process to run the htop program. The forked process has the same stdin stdout and stderr as zsh.
1. htop prints to stdout (PTY slave).
1. PTY slave passes the output to PTY master, which passes it on to gnome-terminal.
1. Gnome-terminal reads the output and redraws the UI. The read is a loop, any change in the htop output reflects on the display in real-time.

several processes can have /dev/pts/0 attached to their standard input. But only
the foreground job will receive input from the TTY. Likewise, only the foreground
job will be allowed to write to the TTY device (in the default configuration).

## Terminal escape code

The way for programs to control the terminal is standardized by the ANSI escape
codes. When the terminal reads them from the pty master will perform the
operation associated with the code.

Want to change the color of the text from your program?
Just print to standard out the ANSI escape code for coloring the text.
Standard out is the PTY slave, TTY driver copies the character to the PTY master,
terminal gets the code and understands it needs to set the color to print the
text on the screen.

https://en.wikipedia.org/wiki/ANSI_escape_code
https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Mouse-Tracking


##nomenclature & command

* tty - tele-type
* pty - pseudo tele-type
* ptmx - pseudo-teletype multiplexor
* pts - pseudo terminal slave

### command
* tty - print the name of the device used by teletype
* stty - settings tty - utility to query and change the line discipline rules for the device connected to its standard input.
* ldattach - line discipline attach.
* ps - process
* who - who is connected and on which terminal.

## Reference

https://www.oreilly.com/library/view/linux-device-drivers/0596005903/ch18.html
https://ishuah.com/2021/02/04/understanding-the-linux-tty-subsystem/
https://www.linusakesson.net/programming/tty/
https://www.howtogeek.com/428174/what-is-a-tty-on-linux-and-how-to-use-the-tty-command/
https://dev.to/napicella/linux-terminals-tty-pty-and-shell-part-2-2cb2
https://unix.stackexchange.com/questions/117981/what-are-the-responsibilities-of-each-pseudo-terminal-pty-component-software
https://www.yabage.me/2016/07/08/tty-under-the-hood/
https://dvdhrm.wordpress.com/2013/08/24/session-management-on-linux/
