FROM golang:1.23-alpine AS moor-build
RUN apk add git
RUN git clone --branch go https://github.com/dimacurrentai/moor /src/moor
RUN cd /src/moor && go build -o /moor .

FROM alpine:3.20
RUN apk update
RUN apk add zsh zsh-vcs vim curl difftastic apg git su-exec nodejs npm jq yq
RUN npm install -g @anthropic-ai/claude-code
COPY --from=moor-build /moor /usr/local/bin/moor

COPY .zshrc .dima.shellrc /etc/skel/
COPY docker/dk/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /etc/skel/.cache/zsh

ENV TERM=xterm-256color
ENV PAGER=moor
ENV GIT_PAGER=moor
ENTRYPOINT ["/entrypoint.sh"]
