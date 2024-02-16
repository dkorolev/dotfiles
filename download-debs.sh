#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

ALL_APT_PACKAGES=””

for i in $(cat ${SCRIPT_DIR}/apt-packages.txt | grep -v '^#'); do ALL_APT_PACKAGES="$ALL_APT_PACKAGES $i"; done

# Ref. https://unix.stackexchange.com/questions/367942/make-apt-cache-depends-only-recurse-over-preferred-alternative
DEBS=$(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --no-pre-depends -o APT::Cache::ShowOnlyFirstOr=true ${ALL_APT_PACKAGES} | grep "^\w")

mkdir -p deb
for i in $DEPS ; do
  if ! [ -d deb/$i ] ; then
    rm -rf  deb/$i.tmp
    mkdir -p deb/$i.tmp
    (cd deb/$i.tmp; apt-get download $i) && mv deb/$i.tmp deb/$i || echo $i >>deb/errors.txt
  fi
done
