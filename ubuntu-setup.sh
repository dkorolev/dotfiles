#!/bin/bash
#
# This "script" is meant to be copy-pasted into a fresh Ubuntu.
#
# Testing under WSL, because why not?

# TODO tomorrow: Add `../current` and `../../current` into the YCM header path.

sudo apt-get -y update
sudo apt-get install -y git

git clone https://github.com/dkorolev/dotfiles ~/.dotfiles

ALL_APT_PACKAGES=""
for i in $(cat .dotfiles/apt-packages.txt); do ALL_APT_PACKAGES="$ALL_APT_PACKAGES $i"; done

time sudo apt-get install -y $ALL_APT_PACKAGES

sudo mkdir -p /usr/lib/android-sdk/licenses
sudo chmod a+rw  /usr/lib/android-sdk/licenses
sudo mkdir -p /opt/android-sdk
sudo chmod a+rw  /opt/android-sdk
yes | sdkmanager --licenses

cp $(find .dotfiles/ -maxdepth 1 -name '.*' -type f) .

sudo chsh -s $(which zsh) $(whoami)

git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/Valloric/YouCompleteMe ~/.vim/pack/plugins/opt/YouCompleteMe
(cd ~/.vim/pack/plugins/opt/YouCompleteMe; ./install.py --all)
