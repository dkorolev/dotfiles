FROM alpine:3.20
RUN apk update
RUN apk add zsh vim curl difftastic apg git

COPY .zshrc .dima.shellrc /root/
RUN mkdir -p /root/.cache/zsh

ENV TERM=xterm-256color
CMD ["zsh"]
