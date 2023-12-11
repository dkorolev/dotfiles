# This is the test/demo Ubuntu container which installs all the `dotfiles`.
#
# I might use it for development some time in the future, but no immediate plans.
# The goal mostly is to polish the repo to the state when setting up my new machine is trivial.
#
# Also, YouCompleteMe is quite a beast, so it's nice to have a reproducible setup.

FROM ubuntu:latest

RUN apt-get -y update

RUN DEBIAN_FRONTEND=noninteractive TZ=UTC apt-get -y install tzdata

RUN apt-get install -y git zsh vim curl jq screen sudo npm wget build-essential cmake python3 python3-dev golang nodejs default-jdk

RUN useradd -rm -d /home/dev -s /usr/bin/zsh -g root -G sudo -u 1001 dev
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dev
WORKDIR /home/dev

RUN (cd /home/dev; git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/Valloric/YouCompleteMe ~/.vim/pack/plugins/opt/YouCompleteMe)

# NOTE(dkorolev): `--all` can be replaced by `--clangd-completer` or `--clang-completer`, or even `--Rust` or `--Go`.
RUN (cd /home/dev/.vim/pack/plugins/opt/YouCompleteMe; ./install.py --all)

RUN git clone https://github.com/dkorolev/dotfiles ~/.dotfiles
RUN cp ~/.dotfiles/.zshrc /home/dev/
RUN cp ~/.dotfiles/.vimrc /home/dev/
RUN cp ~/.dotfiles/.inputrc /home/dev/
RUN cp ~/.dotfiles/.screenrc /home/dev/

ENTRYPOINT ["/usr/bin/zsh"]
