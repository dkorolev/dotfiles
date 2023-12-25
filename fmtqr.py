#!/usr/bin/env python3
#
# Usage: qrencode -t ascii "Test string!" | python3 ~/fmtqr.py
#
# Require `pip install colorama`, or `sudo apt-get install python3-colorama` on Ubuntu.
#
# TODO(dkorolev): Don't print '#'-s in Android/Termux, doesn't work as intended.

import sys 
from colorama import Back, Style
lines = []
max_width = 0 
for line in sys.stdin:
  lines.append(line)
  max_width = max(max_width, len(line))
for line in lines:
  black = None
  for i in range(max_width):
    if i < len(line) and line[i] == "#":
      if not black == True:
        black = True
        print(Back.BLACK, end="")
      print("#", end="")
    else:
      if not black == False:
        black = False
        print(Back.WHITE, end="")
      print(" ", end="")
  print(Style.RESET_ALL)
