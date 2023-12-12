#!/usr/bin/env python3
#
# Usage: qrencode -t ascii "Test string!" | python3 ~/fmtqr.py
#
# Require `pip install colorama`.

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
    if i >= len(line) or line[i] == "#":
      if not black == True:
        black = True
        print(Back.BLACK, end="")
    else:
      if not black == False:
        black = False
        print(Back.WHITE, end="")
    print(" ", end="")
  print(Style.RESET_ALL)
