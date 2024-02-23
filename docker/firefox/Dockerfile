# This is a minimalistic `Dockerfile` for Firefox to run inside `podman`.
# More details in `../xclock`.

FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:mozillateam/ppa
RUN apt-get -y install firefox-esr

ARG UNAME
ARG UID
ARG GID

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

USER $UNAME
WORKDIR /home/$UNAME
