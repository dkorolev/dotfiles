#!/bin/bash
#
# This script is meant to be run from the GUI of the user that was just created.
#
# Friendly reminders:
# 1) Run `./dkorolev_setup_system.sh` first, to set up the system before setting up users.
# 2) The recommended way to create users is `sudo adduser --encrypt-home {DESIRED_USERNAME}`.

# Set the shell to zsh.
chsh -s $(which zsh) $(whoami)

# Install the dotfiles.
for i in $(find /var/dotfiles/ -maxdepth 1 -name '.*' -type f) ; do cp $i ~ ; chown $(whoami): ~/$(basename $i) ; done

# Install YCM.

if ! [ -s ~/.ycm_installed ] ; then
  T_BEGIN=$(date +%s)

  git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/Valloric/YouCompleteMe ~/.vim/pack/plugins/opt/YouCompleteMe

  T_YCM_CLONE_DONE=$(date +%s)

  echo
  echo "YCM clone took $((T_YCM_CLONE_DONE-T_BEGIN))s."
  echo
  (cd ~/.vim/pack/plugins/opt/YouCompleteMe; ./install.py --all)

  T_YCM_DONE=$(date +%s)

  echo
  echo "YCM build took $((T_YCM_DONE-T_YCM_CLONE_DONE))s."
  echo

  echo "yes" > ~/.ycm_installed
fi

# Background TBD.
(cd ~/Pictures; wget http://dima.ai/static/background.jpg)
gsettings set org.gnome.desktop.background picture-uri "file:///home/$(whoami)/Pictures/background.jpg"
