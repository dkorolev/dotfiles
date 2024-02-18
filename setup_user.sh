#!/bin/bash
#
# This script is meant to be run from the GUI of the user that was just created.
#
# Friendly reminders:
# 1) Run `./dkorolev_setup_system.sh` first, to set up the system before setting up users.
# 2) The recommended way to create users is `sudo adduser --encrypt-home $U`.
# 3) Don't forget to run `sudo ./govern_user.sh $U` right after adding the user.
#
# Please refer to the README for more details.

set -e

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

if ! [ -d /var/dotfiles ] ; then
  echo 'Expecting to have the `/var/dotfiles` dir created during the system setup phase.'
  exit 1
fi

U=$(whoami)

# Set the shell to zsh.
ZSH=$(which zsh)
if [ "$ZSH" != "$SHELL" ] ; then
  chsh -s "$ZSH" $U
else
  echo 'The shell is already `zsh`.'
fi

# Install the dotfiles.
for i in $(find /var/dotfiles/ -maxdepth 1 -name '.*' -type f) ; do
  cp $i ~
  chmod +w ~/$(basename $i)
  chown $U: ~/$(basename $i)
done

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
else
  echo 'YCM is already installed.'
fi

# If there is a profile to restore.

if [ -f "/var/userdata/$U.tar.gz.des3" ] ; then
  echo 'A profile to restore is present. Restoring.'

  DIR=~/.unpacked.$(date +%s)
  mkdir $DIR
  (cd $DIR; openssl des3 -d -pbkdf2 <"/var/userdata/$U.tar.gz.des3" | tar xz)

  # Chrome
  CHROME_BASE=$("$SCRIPT_DIR/chrome_default_profile_base_dir.sh" $U)
  if [ "$CHROME_BASE" != "" ] ; then
    if [ -d "$CHROME_BASE/Default" ] ; then
      mv "$CHROME_BASE/Default" "$CHROME_BASE/Default.$(date +%s)"
    fi
    mv $DIR/Default "$CHROME_BASE"
    echo 'Chrome `Default` installed.'
  else
    echo 'Now seeing Chrome `Default` dir, ignoring Chrome profile setup.'
  fi

  # Wallpaper.
  if [ -f $DIR/Downloads/wall.jpg ] ; then
    echo 'Has wallpaper.'
    WALL="/home/$U/Pictures/wall-$(date +%s).jpg"
    cp $DIR/Downloads/wall.jpg "$WALL"
  else
    echo 'Using the defaut wallpaper.'
    [ -f ~/Pictures/background.jpg ] || (cd ~/Pictures; wget http://dima.ai/static/background.jpg)
    WALL="/home/$U/Pictures/background.jpg"
  fi
  gsettings set org.gnome.desktop.background picture-uri "file://${WALL}"

  # Profile pic.
  if [ -f $DIR/Downloads/icon.png ] ; then
    echo 'Has icon.'
    cat $DIR/Downloads/icon.png >/var/lib/AccountsService/icons/$U && echo 'Icon setup OK.' || echo 'Icon fail.'
  else
    echo 'No icon.'
  fi
else
  echo 'No profile to restore was found.'
fi
