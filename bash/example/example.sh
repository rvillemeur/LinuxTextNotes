#!/bin/bash

# exemple d'utilisation de python avec stdin et stdout
./python_command_line.py < input.txt > output.txt 2> err.txt

# autre example avec pipe
#cat input.txt | ./python_command_line.py > output2.txt

