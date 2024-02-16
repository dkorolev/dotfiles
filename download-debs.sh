#!/bin/bash

ALL_APT_PACKAGES=””

for i in $(cat apt-packages.txt | grep -v '^#'); do ALL_APT_PACKAGES="$ALL_APT_PACKAGES $i"; done

time \
  apt-get download \
  $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --no-pre-depends ${ALL_APT_PACKAGES} | grep "^\w")
