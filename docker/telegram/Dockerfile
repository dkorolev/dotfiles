FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install telegram-desktop
#RUN apt-get -y install screen

ARG UNAME
ARG UID
ARG GID

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

USER $UNAME
WORKDIR /home/$UNAME

RUN mkdir -p "/home/$UNAME/.local/share/"

ENTRYPOINT ["telegram-desktop"]
