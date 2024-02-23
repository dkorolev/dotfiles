#!/bin/bash

set -e

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

U="$(whoami)"

(cd "$SCRIPT_DIR"; podman build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME="$U" .)
C="$(cd "$SCRIPT_DIR"; podman build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME="$U" -q .)"

mkdir -p "/home/$U/.tg-app"
chmod a+w "/home/$U/.tg-app"

(cd "$SCRIPT_DIR";
 xhost +;
 podman run --net host -v "/home/$U/.tg-app":"/home/$U/.local/share/TelegramDesktop" -e DISPLAY -it "$C")
