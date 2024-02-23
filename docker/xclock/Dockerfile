# This is the baseline Dockerfile for X integration.
#
# What it does is:
#
# - Create the user and group, same as the caller.
# - Make them a `sudo`-enabled user.
# - Install a few base packages.
# - Including `x11-apps`, which contains `x11-clock`.
#
# Proxying the right user requiring providing the user name plus the UID + GID while building the container, see below.
#
# Run instructions:
#
# In my (@dkorolev): `.zshrc` I have three aliases:
#
# alias db='podman build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$(whoami) .'
# alias dr='podman run --net host -e DISPLAY -it $(podman build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$(whoami) -q .)'
#
# The `db` one stands for `docker build` from the current directory, passing all three user-related arguments.
# It uses Podman, but should work with Docker too.
#
# The `dr` one is `docker run`, although it uses Podman too.
#
# The `drx` one is same as `dr`, but it also executes `xhost +` beforehand, making sure X forwarding is enabled by the host.
#
# With the above aliases and with this `Dockerfile`, just `drx xclock` should open the clock.
#
# If you are not comfortable with `xhost +` being on on your host machine as a side effect,
# disable it with `xhost -`, and/or control it manually and use `dr`, not `drx`.
#
# Note: The time zone for `xclock` can and likely will be off. That is, unless you're in UTC =)

FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update

RUN apt-get -y install sudo net-tools
RUN apt-get -y install x11-apps

RUN groupadd gandalf
RUN echo '%gandalf ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ARG UNAME
ARG UID
ARG GID

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
RUN usermod -aG gandalf $UNAME

USER $UNAME
# NOTE(dkorolev): Using `USER $UNAME:$UID` somehow does not grant the user `sudo` within the container.'

WORKDIR /home/$UNAME
