FROM alpine:3.20
RUN apk update
RUN apk add zsh zsh-vcs vim curl difftastic apg git su-exec

COPY .zshrc .dima.shellrc /etc/skel/
COPY docker/dk/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /etc/skel/.cache/zsh

ENV TERM=xterm-256color
ENTRYPOINT ["/entrypoint.sh"]
