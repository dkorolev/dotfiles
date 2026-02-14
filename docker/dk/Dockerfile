FROM golang:1.23-bookworm AS go-build
RUN git clone --branch go https://github.com/dimacurrentai/moor /src/moor
RUN cd /src/moor && go build -o /moor .

FROM rust:bookworm AS difft-build
RUN cargo install --locked difftastic

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh git vim curl ca-certificates apg gosu nodejs npm jq yq \
    && rm -rf /var/lib/apt/lists/*
RUN npm install -g @anthropic-ai/claude-code
COPY --from=go-build /moor /usr/local/bin/moor
COPY --from=difft-build /usr/local/cargo/bin/difft /usr/local/bin/difft

COPY .zshrc .dima.shellrc /etc/skel/
COPY docker/dk/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /etc/skel/.cache/zsh

ENV TERM=xterm-256color
ENV PAGER=moor
ENV GIT_PAGER=moor
ENTRYPOINT ["/entrypoint.sh"]
