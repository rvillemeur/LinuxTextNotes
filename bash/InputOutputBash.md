[source](https://mywiki.wooledge.org/BashGuide/InputAndOutput)

# Input And Output
Input and output in Bash scripts is a complex topic, because there is a great 
deal of flexibility in how it's done. This chapter will only scratch the surface 
of what is possible.

Input refers to any information that your program receives (or reads). Input to 
a Bash script can come from several different places:
- Command-line arguments (which are placed in the positional parameters)
- Environment variables, inherited from whatever process started the script
- Files
- Anything else a File Descriptor can point to (pipes, terminals, sockets, 
- etc.). This will be discussed below.

Output refers to any information that your program produces (or writes). Output 
from a Bash script can also go to lots of different places:

- Files
- Anything else a File Descriptor can point to
- Command-line arguments to some other program
- Environment variables passed to some other program
- Input and output are important in shell script programming. Figuring out where your input comes from, what it looks like, and what you must do to it in order to produce your desired output are core requirements for almost all scripts.



## Command-line Arguments

For many scripts, the first (or the only) input we will care about are the 
arguments received by the script on the command line. As we saw in the 
Parameters chapter, there are some Special Parameters available to every script 
which contain these arguments. These are called the Positional Parameters. They 
are a very simple numerically indexed array of strings (in fact, in the POSIX 
shell, they are the only array the shell has). The first positional parameter is 
referred to with $1; the second, with $2; and so on. After the 9th one, you must 
use curly braces to refer to them: ${10}, ${11}, etc. But in practice, it's 
exceedingly rare that you would ever need to do that, because there are better 
ways to deal with them as a group.

In addition to referring to them one at a time, you may also refer to the entire 
set of positional parameters with the "$@" substitution. The double quotes here 
are **extremely important**. If you don't use the double quotes, each one of the 
positional parameters will undergo word splitting and globbing. You don't want 
that. By using the quotes, you tell Bash that you want to preserve each 
parameter as a separate word.

Another way to deal with the positional parameters is to eliminate each one as 
it is used. There is a special builtin command named shift which is used for 
this purpose. When you issue the shift command, the first positional parameter 
($1) goes away. The second one becomes $1, the third one becomes $2, and so on 
down the line. So, if you wish, you can write a loop that keeps using $1 over 
and over.

In real scripts, a combination of these techniques is used. A loop to process $1 
as long as it begins with a - takes care of the options. Then, when all the 
options have been processed and shifted away, everything that's left (in "$@") 
is presumably a filename that we want to process.

For brevity, we will not include examples of argument processing here. Instead, 
we will refer to the FAQ where those examples have already been written.


**Good Practice:**
Identify where your input comes from before you start writing. If you get to 
design the data flow into your script, then choose a way that makes sense for 
the kind of data you're dealing with. If you need to pass filenames, passing 
them as arguments is an excellent approach, because each one is encapsulated as 
a word, ready to go.


## The Environment

Every program inherits certain information, resources, privileges and 
restrictions from its parent process. (For a more advanced discussion of this 
topic, see process management.) One of those resources is a set of variables 
called Environment Variables.

In Bash, environment variables work very much like the regular shell variables 
we're used to. The only real difference is that they're already set when the 
script starts up; we don't have to set them ourselves.

Traditionally, environment variables have names that are all capital letters, 
such as PATH or HOME. This helps you avoid creating any variables that would 
conflict with them; as long as your variables all contain at least one 
lower-case letter, you should never have to worry about accidentally colliding 
with the environment. (Bash's special variables are also capitalized, such as 
PIPESTATUS. This is done for the exact same reason -- so you can avoid having 
your variables trampled by Bash.)

Passing information to a program through the environment is useful in many 
situations. One of those is user preference. Not every user on a Unix-like 
system has the same likes and dislikes in applications, and in some cases, they 
may not all speak the same language. So, it's useful for users to be able to 
tell every application they run what their favorite editor is (the EDITOR 
environment variable), or what language they speak (the various environment 
variables that compose the user's locale). Environment variables can be set in 
each user's DotFiles, and then they will be passed automatically to every 
program the user runs from the login session.

Environment variables can also be tweaked on the fly extremely easily (more 
easily than if the same information were stored in a file). When you run a 
command in Bash, you have the option of specifying a temporary environment 
change which only takes effect for the duration of that command. This is done by 
putting VAR=value in front of the command. Here is an example:

```bash
$ ls /tpm
ls: no se puede acceder a /tpm: No existe el fichero o el directorio
$ LANG=C ls /tpm
ls: cannot access /tpm: No such file or directory
```

The LANG=C temporary environment will not cause the user's locale to change for 
anything other than the one command where it was typed.

In a script, if you know that some information is in an environment variable, 
you can just use it like any other variable:

```bash`
if [[ $DISPLAY ]]; then
    xterm -e top
else
    top
fi
```

This runs xterm -e top if the environment variable DISPLAY is set (and not 
empty); otherwise, it runs top.

If you want to put information into the environment for your child processes to 
inherit, you use the export command:

```bash
export MYVAR=something
```

The tricky part here is that your environment changes are only inherited by your 
descendants. You can't change the environment of a program that is already 
running, or of a program that you don't run.

Changing the environment and then running some other program is extremely 
common. A script that does this as its primary task is called a WrapperScript.


**Good Practice:**
Don't use all-capital variable names in your scripts, unless they are 
environment variables. Use lower-case or mixed-case variable names, to avoid 
accidents.


### File Descriptors

File Descriptors (in short: FDs) are the way programs refer to files, or to 
other resources that work like files (such as pipes, devices, sockets, or 
terminals). FDs are kind of like pointers to sources of data, or places data can 
be written. When something reads from or writes to that FD, the data is read 
from or written to that FD's resource.

By default, every new process starts with three open FDs:
- Standard Input (stdin): File Descriptor 0
- Standard Output (stdout): File Descriptor 1
- Standard Error (stderr): File Descriptor 2

In an interactive shell, or in a script running on a terminal, the Standard 
Input is how bash sees the characters you type on your keyboard. The Standard 
Output is where the program sends most of its normal information so that the 
user can see it, and the Standard Error is where the program sends its error 
messages.

GUI applications also have these FDs, but they don't normally work with them. 
Usually, they do all their user interaction via the GUI, making it hard for BASH 
to control them. As a result, we'll stick to simple terminal applications. With 
those, we can easily feed data to them on their Standard Input, and read data 
from them on their Standard Output and Standard Error.

Let's make these definitions a little more concrete. Here's a demonstration of 
how Standard Input and Standard Output work:

```bash`
$ read -p "What is your name? " name; echo "Good day, $name.  Would you like some tea?"
What is your name? lhunath
Good day, lhunath.  Would you like some tea?
```

`read` is a command that reads information from stdin and stores it in a variable. 
We specified name to be that variable. Once read has read a line of information 
from stdin, it finishes and lets echo display a message. echo sends its output 
to stdout. stdin and stdout are connected to your terminal. When a program reads 
from a terminal, it receives keystrokes from your keyboard; when it writes to a 
terminal, characters are displayed on your monitor. As a result, you can type in 
your name and are then greeted with a friendly message on your monitor, offering 
you a cup of tea.

So what is `stderr`? Let's demonstrate:

```bash`
$ rm secrets
rm: cannot remove `secrets': No such file or directory
```

Unless you have a file called secrets in your current directory, that rm command 
will fail and show an error message explaining what went wrong. Error messages 
like these are by convention displayed on stderr.

`stderr` is also connected to your terminal's output device, just like stdout. 
As a result, error messages display on your monitor just like the messages on 
stdout. However, the distinction between stdout and stderr makes it easy to keep 
errors separated from the application's normal messages. For example, a script 
might wish to log stderr messages in a special place for long-term storage. Some 
people also like to use wrappers to make all the output on stderr red, so that 
they can see the error messages more clearly. (This doesn't work as well as one 
might wish, but some people find it good enough for some tasks.)

In shell scripts, FDs are always referenced by number. In the next section, we 
will see some of the ways we can work with FDs using their numbers.


**Good Practice:**
Remember that when you create scripts, you should send your custom error messages to the stderr FD. This is a convention and it is very convenient when applications follow the convention. As such, so should you! You're about to learn redirection soon, but let me show you quickly how it's done:

```bash
 echo "Uh oh.  Something went really bad.." >&2
```

*File Descriptor*: A numeric index referring to one of a process's open files. 
Each command has at least three basic descriptors: FD 0 is stdin, FD 1 is stdout 
and FD 2 is stderr.



## Redirection

The most basic form of input/output manipulation in BASH is Redirection. 
Redirection is used to change the data source or destination of a program's FDs. 
That way, you can send output to a file instead of the terminal, or have an 
application read from a file instead of from the keyboard.

Redirections are performed by BASH (or any other shell), before the shell runs 
the command to which the redirections are applied.

*Redirection*: the practice of changing a FD to read its input from, or send its 
output to, a different location.



### File Redirection

File Redirection involves changing a single FD to point to a file. Let's start 
with an output redirection:

```bash
$ echo "It was a dark and stormy night.  Too dark to write." > story
$ cat story
It was a dark and stormy night.  Too dark to write.
```

The > operator begins an output redirection. The redirection applies only to one 
command (in this case, an echo command). It tells BASH that when BASH runs the 
command, stdout should point to a file, rather than wherever it was pointing 
before.

As a result, the echo command will not send its output to the terminal; rather, 
the > story redirection changes the destination of the stdout FD so that it now 
points to a file called story. Be aware that this redirection occurs before the 
echo command is executed. By default, Bash doesn't check to see whether that 
file story exists first; it just opens the file, and if there was already a file 
by that name, its former contents are lost. If the file doesn't exist, it is 
created as an empty file, so that the FD can be pointed to it. This behaviour 
can be toggled with Shell Options (see later).

It should be noted that this redirection is in effect only for the single echo 
command it was applied to. Other commands executed after that will continue 
sending their output to the script's stdout location.

We then use the application cat to print out the contents of that file. cat is 
an application that reads the contents of all the files you pass it as 
arguments. It then writes each file one after another on stdout. In essence, it 
concatenates the contents of all the files you pass it as arguments.

**Warning**: Far too many code examples and shell tutorials on the Internet tell 
you to use cat whenever you need to read the contents of a file. This is not 
necessary! cat only serves well to concatenate multiple files together, or as a 
quick tool on the shell prompt to see what's inside a file. You should NOT use 
cat to pipe files to commands in your scripts. Instead, you should use a 
redirection. Please keep this warning in mind. Useless use of cat will result in 
an extra process to create, and using a pipe instead of a redirection takes away 
an application's ability to skip back and forth inside the input file.

When we use cat without passing any kind of arguments, it obviously doesn't know 
what files to read. In this case, cat will just read from stdin instead of from 
a file (much like read). Since stdin is normally not a regular file, starting 
cat without any arguments will seem to do nothing:

```bash
$ cat
```

It doesn't even give you back your shell prompt! What's going on? cat is still 
reading from stdin, which is your terminal. Anything you type on your keyboard 
now will be sent to cat as soon as you hit the Enter key. With each line you 
type, cat will do what it normally does: display it reads on stdout, the same 
way as when it displayed our story on stdout.

```bash`
$ cat
test?
test?
```

Why does it say test? twice now? First of all, terminals are actually more 
complicated than they appear; they have different modes of operation. The mode 
we are using in this example is called canonical mode, and in this mode, the 
terminal shows you each character as you type it, and lets you perform extremely 
simple editing (such as using the Backspace key) on your input. The stuff you 
type is not actually sent to the application until you press Enter.

As you type test?, you will see it echoed on the screen by the terminal itself. 
Once you press Enter, the whole line becomes available to the application (cat) 
that's reading from the terminal. cat reads the line from stdin, and then shows 
it on stdout, which is also your terminal; hence, the second line: test?.

You can press Ctrl+D to send your terminal the End of File character. That'll 
cause cat to think stdin has closed. It will stop reading, and terminate. BASH 
will see that cat has terminated, and return you to your prompt.

Now let's use an input redirection to attach a file to stdin, so that stdin is 
no longer reading from our keyboard, but instead, now reads from the file:

```bash
$ cat < story
The story of William Tell.

It was a cold december night.  Too cold to write.
```

The result of this is exactly the same as the result from our previous cat 
story; except this time, the way it works is a little different. In our first 
example, cat opened an FD to the file story and read its contents through that 
FD. In the second example, cat simply reads from stdin, just like it did when it 
was reading from our keyboard. However, this time, the < story operation has 
modified cat's stdin so that its data source is the file story rather than our 
keyboard.

Redirection operators can be preceded by a number. That number denotes the FD 
that will be changed.

Let's summarize with some examples:
- command > file: Send the stdout of command to file.
- command 1> file: Send the stdout of command to file. Since stdout is FD 1, that's the number we put in front of the redirection operator. This is identical to the previous example, because FD 1 is the default for the > operator.
- command < file: Use the contents of file when command reads from stdin.
- command 0< file: Use the contents of file when command reads from stdin, exactly as in the previous example, since FD 0 (stdin) is the default for the < operator.

The number for the stderr FD is 2. So, let's try sending stderr to a file:

```bash
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2> errors
```

In this example, we're looping over each directory (or file) in /home. We then 
try to delete the file secret in each of them. Some homedirs may not have a 
secret, or we may not have permission to remove it. As a result, the rm 
operation will fail and send an error message on stderr.

You may have noticed that our redirection operator isn't on rm, but it's on that 
done thing. Why is that? Well, this way, the redirection applies to all output 
to stderr made inside the whole loop. Technically, what happens is BASH opens 
the file named errors and points stderr to it before the loop begins, then 
closes it when the loop ends. Any commands run inside the loop (such as rm) 
inherit the open FD from BASH.

Let's see what the result of our loop was:

```bash
$ cat errors
rm: cannot remove `/home/axxo/secret': No such file or directory
rm: cannot remove `/home/lhunath/secret': No such file or directory
```

Two error messages in our error log file. Two people that didn't have a secret file in their home directory.

If you're writing a script, and you expect that running a certain command may 
fail on occasion, but don't want the script's user to be bothered by the 
possible error messages that command may produce, you can silence a FD. 
Silencing it is as easy as normal File Redirection. We're just going to send all 
output to that FD into the system's black hole:

```bash
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2> /dev/null
```

The file /dev/null is always empty, no matter what you write to it or read from 
it. As such, when we write our error messages to it, they just disappear. The 
/dev/null file remains as empty as ever before. That's because it's not a normal 
file; it's a virtual device. Some people call /dev/null the bit bucket.

There is one last thing you should learn about File Redirection. It's 
interesting that you can make error log files like this to keep your error 
messages; but as I mentioned before, Bash destroys the existing contents of a 
file when it redirects to it. As a result, each time we run our loop to delete 
secret files, our log file will be truncated empty before we fill it up again 
with new error messages. What if we'd like to keep a record of any error 
messages generated by our loop? What if we don't want that file to be truncated 
each time we start our loop? The solution is achieved by doubling the 
redirection operator. > becomes >>. >> will not empty a file; it will just 
append new data to the end of it!

```bash
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2>> errors
```

Hooray!

By the way, the space between the redirection operator and the filename is 
optional. Some people write > file and some write >file. Both ways are correct.


**Good Practice:**
It's a good idea to use redirection whenever an application needs file data and 
is built to read data from stdin. A lot of bad examples on the Internet tell you 
to pipe (see later) the output of cat into processes; but this is nothing more 
than a very bad idea.
When designing an application that could be fed data from a variety of different 
sources, it is often best simply to have your application read from stdin; that 
way, the user can use redirection to feed it whatever data she wishes. An 
application that reads standard input in a generalized way is called a filter.



### File Descriptor Manipulation

Now that you know how to manipulate process input and output by sending it to 
and reading it from files, let's make it a little more interesting still.

It's possible to change the source and destination of FDs to point to or from 
files, as you know. It's also possible to copy one FD to another. Let's prepare 
a simple testbed:


$ echo "I am a proud sentence." > file
We've made a file called file, and written a proud sentence into it.

There's an application called grep that we've seen briefly in a previous 
chapter. grep is like duct tape: you can use it in almost any project (whether 
it's a good idea or not). It basically takes a search pattern as its first 
argument and maybe some filenames as extra arguments. Just like cat, grep also 
uses stdin if you don't specify any files. grep reads the files (or stdin if 
none were provided) and searches for the search pattern you gave it. Most 
versions of grep even support a -r switch, which makes it take directories as 
well as files as extra arguments, and then searches all the files and 
directories in those directories that you gave it. Here's an example of how grep 
can work:


$ ls house/
drawer  closet  dustbin  sofa
$ grep -r socks house/
house/sofa:socks

In this silly example we have a directory called house with several pieces of 
furniture in it as files. If we're looking for our socks in each of those files, 
we send grep to search the directory house/. grep will search everything in 
there, open each file and look through its contents. In our example, grep finds 
socks in the file house/sofa; presumably tucked away under a pillow. You want a 
more realistic example? Sure:


$ grep "$HOSTNAME" /etc/*
/etc/hosts:127.0.0.1       localhost Lyndir
Here we instruct grep to search for whatever $HOSTNAME expands to in whatever 
files /etc/* expands to. It finds my hostname, which is Lyndir, in the file 
/etc/hosts, and shows me the line in that file that contains the search pattern.

OK, now that you understand grep, let's continue with our File Descriptor 
Manipulation. Remember that we created a file called file, and wrote a proud 
sentence to it? Let's use grep to find where that proud sentence is now:


$ grep proud *
file:I am a proud sentence.
Good! grep found our sentence in file. It writes the result of its operation to 
stdout which is shown on our terminal. Now let's see if we can make grep send an 
error message, too:


$ grep proud file 'not a file'
file:I am a proud sentence.
grep: not a file: No such file or directory

This time, we instruct grep to search for the string proud in the files 'file' 
and 'not a file'. file exists, and the sentence is in there, so grep happily 
writes the result to stdout. It moves on to the next file to scan, which is 'not 
a file'. grep can't open this file to read its content, because it doesn't 
exist. As a result, grep emits an error message on stderr which is still 
connected to our terminal.

Now, how would you go about silencing this grep statement completely? We'd like 
to send all the output that appears on the terminal to a file instead; let's 
call it proud.log:


# Not quite right....
$ grep proud file 'not a file' > proud.log 2> proud.log

Does that look about right? We first use > to send stdout to proud.log, and then 
use 2> to send stderr to proud.log as well. Almost, but not quite. If you run 
this command (at least on some computers), and then look in proud.log, you'll 
see there's only an error message, not the output from stdout. We've created a 
very bad condition here. We've created two FDs that both point to the same file, 
independently of each other. The results of this are not well-defined. Depending 
on how the operating system handles FDs, some information written via one FD may 
clobber information written through the other FD.


$ echo "I am a very proud sentence with a lot of words in it, all for you." > 
file2
$ grep proud file2 'not a file' > proud.log 2> proud.log
$ cat proud.log
grep: not a file: No such file or directory
of words in it, all for you.

What happened here? grep opened file2 first, found what we told it to look for, 
and then wrote our very proud sentence to stdout (FD 1). FD 1 pointed to 
proud.log, so the information was written to that file. However, we also had 
another FD (FD 2) pointed to this same file, and specifically, pointed to the 
beginning of this file. When grep tried to open 'not a file' to read it, it 
couldn't. Then, it wrote an error message to stderr (FD 2), which was pointing 
to the beginning of proud.log. As a result, the second write operation overwrote 
information from the first one!

We need to prevent having two independent FDs working on the same destination or 
source. We can do this by duplicating FDs:


$ grep proud file 'not a file' > proud.log 2>&1
In order to understand these, you need to remember: always read file 
redirections from left to right. This is the order in which Bash processes them. 
First, stdout is changed so that it points to our proud.log. Then, we use the >& 
syntax to duplicate FD 1 and put this duplicate in FD 2.

A duplicate FD works differently from having two independent FDs pointing to the 
same place. Write operations that go through either one of them are exactly the 
same. There won't be a mix-up with one FD pointing to the start of the file 
while the other has already moved on.

Be careful not to confuse the order:


$ grep proud file 'not a file' 2>&1 > proud.log
This will duplicate stdout (which points to the terminal) and put the duplicate 
in stderr, and then stdout will be redirected to proud.log. As a result, 
stdout's messages will be logged, but the error messages will still go to the 
terminal. Oops.

Note:
For convenience, Bash also makes yet another form of redirection available to 
you. The &> redirection operator is actually just a shorter version of what we 
did here; redirecting both stdout and stderr to a file :


$ grep proud file 'not a file' &> proud.log
This is the same as > proud.log 2>&1, but not portable to BourneShell. It is not 
recommended practice, but you should recognize it if you see it used in someone 
else's scripts.

TODO: Moving FDs and Opening FDs RW.


In the FAQ:
How can I redirect the output of multiple commands at once?

How can I redirect the output of 'time' to a variable or file?

How do I use dialog to get input from the user?

How can I redirect stderr to a pipe?

Tell me all about 2>&1 -- what's the difference between 2>&1 >foo and >foo 2>&1, and when do I use which?



4.3. Heredocs And Herestrings
Sometimes storing data in a file is overkill. We might only have a tiny bit of it -- enough to fit conveniently in the script itself. Or we might want to redirect the contents of a variable into a command, without having to write it to a file first.


$ grep proud <<END
> I am a proud sentence.
> END
I am a proud sentence.
This is a Heredoc (or Here Document). Heredocs are useful if you're trying to embed short blocks of multi-line data inside your script. (Embedding larger blocks is bad practice. You should keep your logic (your code) and your input (your data) separated, preferably in different files, unless it's a small data set.)

In a Heredoc, we choose a word to act as a sentinel. It can be any word; we used END in this example. Choose one that won't appear in your data set. All the lines that follow the first instance of the sentinel, up to the second instance, become the stdin for the command. The second instance of the sentinel word has to be a line all by itself.

There are a few different options with Heredocs. Normally, you can't indent them -- any spaces you use for indenting your script will appear in the stdin. The terminator string (in our case END) must be at the beginning of the line.


echo "Let's test abc:"
if [[ abc = a* ]]; then
    cat <<END
        abc seems to start with an a!
END
fi
Will result in:


Let's test abc:
        abc seems to start with an a!
You can avoid this by temporarily removing the indentation for the lines of your Heredocs. However, that distorts your pretty and consistent indentation. There is an alternative. If you use <<-END instead of <<END as your Heredoc operator, Bash removes any tab characters in the beginning of each line of your Heredoc content before sending it to the command. That way you can still use tabs (but not spaces) to indent your Heredoc content with the rest of your code. Those tabs will not be sent to the command that receives your Heredoc. You can also use tabs to indent your sentinel string.

Bash substitutions are performed on the contents of the Heredoc by default. However, if you quote the word that you're using to delimit your Heredoc, Bash won't perform any substitutions on the contents. Try this example with and without the quote characters, to see the difference:

$ cat <<'XYZ'
> My home directory is $HOME
> XYZ
My home directory is $HOME
The most common use of Heredocs is dumping documentation to the user:

usage() {
    cat <<EOF
usage: foobar [-x] [-v] [-z] [file ...]
A short explanation of the operation goes here.
It might be a few lines long, but shouldn't be excessive.
EOF
}
Now let's check out the very similar but more compact Herestring:


$ grep proud <<<"I am a proud sentence"
I am a proud sentence.
This time, stdin reads its information straight from the string you put after the <<< operator. This is very convenient to send data that's in variables into processes:


$ grep proud <<<"$USER sits proudly on his throne in $HOSTNAME."
lhunath sits proudly on his throne in Lyndir.
Herestrings are shorter, less intrusive and overall more convenient than their bulky Heredoc counterpart. However, they are not portable to the Bourne shell.

Later on, you will learn about pipes and how they can be used to send the output of a command into another command's stdin. Many people use pipes to send the output of a variable as stdin into a command. However, for this purpose, Herestrings should be preferred. They do not create a subshell and are lighter both to the shell and to the style of your shell script:


$ echo 'Wrap this silly sentence.' | fmt -t -w 20
Wrap this silly
   sentence.
$ fmt -t -w 20 <<< 'Wrap this silly sentence.'
Wrap this silly
   sentence.
Technically, Heredocs and Herestrings are themselves redirects just like any other. As such, additional redirections can occur on the same line, all evaluated in the usual order.

$ cat <<EOF > file
> My home dir is $HOME
> EOF
$ cat file
My home dir is /home/greg

Good Practice:
Long heredocs are usually a bad idea because scripts should contain logic, not data. If you have a large document that your script needs, you should ship it in a separate file along with your script. Herestrings, however, come in handy quite often, especially for sending variable content (rather than files) to filters like grep or sed.



5. Pipes
Now that you can effortlessly manipulate File Descriptors to direct certain types of output to certain files, it's time you learn some more ingenious tricks available through I/O redirection.

You can use File Redirection to write output to files or read input from files. But what if you want to connect the output of one application directly to the input of another? That way, you could build a sort of chain to process output. If you already know about FIFOs, you could use something like this to that end:


$ ls
$ mkfifo myfifo; ls
myfifo
$ grep bea myfifo &
[1] 32635
$ echo "rat
> cow
> deer
> bear
> snake" > myfifo
bear
We use the mkfifo command to create a new file in the current directory named 'myfifo'. This is no ordinary file, however, but a FIFO (which stands for First In, First Out). FIFOs are special files that serve data on a First In, First Out-basis. When you read from a FIFO, you will only receive data as soon as another process writes to it. As such, a FIFO never really contains any data. So long as no process writes to it, any read operation on the FIFO will block as it waits for data to become available. The same works for writes to the FIFO -- they will block until another process reads from the FIFO.

In our example, the FIFO called myfifo is read from by grep. grep waits for data to become available on the FIFO. That's why we append the grep command with the & operator, which puts it in the background. That way, we can continue typing and executing commands while grep runs and waits for data. Our echo statement feeds data to the FIFO. As soon as this data becomes available, the running grep command reads it in and processes it. The result is displayed. We have successfully sent data from the echo command to the grep command.

But these temporary files are a real annoyance. You may not have write permissions. You need to remember to clean up any temporary files you create. You need to make sure that data is going in and out, or the FIFO might just end up blocking for no reason.

For these reasons, another feature is made available: Pipes. A pipe basically just connects the stdout of one process to the stdin of another, effectively piping the data from one process into another. The entire set of commands that are piped together is called a pipeline. Let's try our above example again, but using pipes:


$ echo "rat
> cow
> deer
> bear
> snake" | grep bea
bear
The pipe is created using the | operator between two commands that are connected with the pipe. The former command's stdout is connected to the latter command's stdin. As a result, grep can read echo's output and display the result of its operation, which is bear.

Pipes are widely used as a means of post-processing application output. FIFOs are, in fact, also referred to as named pipes. They accomplish the same results as the pipe operator, but through a filename.

Note:
The pipe operator creates a subshell environment for each command. This is important to know because any variables that you modify or initialize inside the second command will appear unmodified outside of it. Let's illustrate:


$ message=Test
$ echo 'Salut, le monde!' | read message
$ echo "The message is: $message"
The message is: Test
$ echo 'Salut, le monde!' | { read message; echo "The message is: $message"; }
The message is: Salut, le monde!
$ echo "The message is: $message"
The message is: Test
Once the pipeline ends, so do the subshells that were created for it. Along with those subshells, any modifications made in them are lost. So be careful!


Good Practice:
Pipes are a very attractive means of post-processing application output. You should, however, be careful not to over-use pipes. If you end up making a pipeline that consists of three or more applications, it is time to ask yourself whether you're doing things a smart way. You might be able to use more application features of one of the post-processing applications you've used earlier in the pipe. Each new command in a pipeline causes a new subshell and a new application to be loaded. It also makes it very hard to follow the logic in your script!


In The Manual: Pipelines


In the FAQ:
I set variables in a loop. Why do they suddenly disappear after the loop terminates? Or, why can't I pipe data to read?

How can two processes communicate using named pipes (fifos)?

How can I redirect stderr to a pipe?

How can I read a file line-by-line?

Tell me all about 2>&1 -- what's the difference between 2>&1 >foo and >foo 2>&1, and when do I use which?



6. Miscellaneous Operators
Aside from the standard I/O operators, bash also provides a few more advanced operators that make life on the shell that much nicer.


6.1. Process Substitution
A cousin of the pipe is the Process Substitution operator, which comes in two forms: <(cmd) and >(cmd). It's a convenient way to get the benefits of temporary files or named pipes without having to create them yourself. Whenever you think you need a temporary file to do something, process substitution might be a better way to handle it.

The >() form is relatively rare, and we won't cover it here, because it'll just confuse things. Once you understand how <() works, >() just does the same thing in reverse (writing instead of reading).

What <() does, is run the command inside the parentheses, and gives you a temporary filename that you can use to read the command's output. The advantage over pipes is that you can use the filename as an argument to a command that expects to see a filename.

For example, let's say you have two files that you'd like to diff, but they aren't sorted yet. You could generate two temporary files, to hold the sorted versions of your original files, and then run diff on those. Or, you could use process substitutions:


$ diff <(sort file1) <(sort file2)
With the <() operator, the command's output is sent through a named pipe (or something similar) that's created by bash. The operator itself in your command is replaced by the filename of that file. After your whole command finishes, the file is cleaned up.

The same thing can be done with any commands whose output you'd like to pass to diff. Imagine you want to see the difference between the output of two commands. Ordinarily, you'd have to put the two outputs in two files and diff those:


$ head -n 1 .dictionary > file1
$ tail -n 1 .dictionary > file2
$ diff -y file1 file2
Aachen                                                        | zymurgy
$ rm file1 file2
Using the process substitution operator, we can do all that with a one-liner and no need for manual cleanup:


$ diff -y <(head -n 1 .dictionary) <(tail -n 1 .dictionary)
Aachen                                                        | zymurgy
The <(..) part is replaced by the temporary FIFO created by bash, so diff actually sees something like this:


$ diff -y /dev/fd/63 /dev/fd/62
Here we see how bash runs diff when we use process substitution. It runs our head and tail commands, sending their respective outputs through the "files" /dev/fd/63 and /dev/fd/62. Then it runs the diff command, passing those filenames where originally we had put the process substitution operators.

The actual implementation differs from system to system. In fact, you can see what the above would actually look like to diff on your box by putting an echo in front of our command:


box1$ echo diff -y <(head -n 1 .dictionary) <(tail -n 1 .dictionary)
diff -y /dev/fd/63 /dev/fd/62

box2$ echo <(cat /dev/null)
/var/tmp//sh-np-605454726
For examples using the >() form, see ProcessSubstitution and Bash FAQ 106.


Good Practice:
Process Substitution gives you a concise way to create temporary FIFOs automatically. They're less flexible than creating your own named pipes by hand, but they're perfect for common short commands like diff that need filenames for their input sources.

