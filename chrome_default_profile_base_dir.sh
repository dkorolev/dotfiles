#!/bin/bash

set -e

if [ $# != 1 ] ; then
  echo 'Need one arg, the user name.'
  exit 1
fi

U="$1"
D="/home/$U/snap/chromium/common/chromium/Default"

if [ -d "$D" ] ; then
  echo "$(dirname "$D")"
  exit 0
else
  exit 1
fi
