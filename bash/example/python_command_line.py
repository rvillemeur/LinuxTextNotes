#!/usr/bin/env python

import sys
import signal
import os
import time

def receiveSignal(signalNumber, frame):
    print('Received:', signalNumber)
        return

stdin_fileno = sys.stdin
stdout_fileno = sys.stdout
stderr_fileno = sys.stderr

for line in stdin_fileno:
    if 'exit' == line.strip():
        stdout_fileno.write('Found exit' + '\n')
        print('Terminating the program')
        stderr_fileno.write('NOT AN ERROR')
        exit(0)
    else:
        print('Message from sys.stdin: ---> {} <---'.format(line))

if __name__ == '__main__':
    # register the signals to be caught
    signal.signal(signal.SIGQUIT, receiveSignal)
    signal.signal(signal.SIGILL, receiveSignal)
    signal.signal(signal.SIGTRAP, receiveSignal)
    signal.signal(signal.SIGABRT, receiveSignal)
    signal.signal(signal.SIGBUS, receiveSignal)
    signal.signal(signal.SIGFPE, receiveSignal)
    #signal.signal(signal.SIGKILL, receiveSignal)
    signal.signal(signal.SIGUSR1, receiveSignal)
    signal.signal(signal.SIGSEGV, receiveSignal)
    signal.signal(signal.SIGUSR2, receiveSignal)
    signal.signal(signal.SIGPIPE, receiveSignal)
    signal.signal(signal.SIGALRM, receiveSignal)
    signal.signal(signal.SIGTERM, receiveSignal)
     # output current process id
     print('My PID is:', os.getpid())

     # wait in an endless loop for signals
     while True:
        print('Waiting...')
        time.sleep(3)

