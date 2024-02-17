#!/bin/bash
#
# This "script" is meant to be run on a fresh Ubuntu installation.
#
# Tested under WSL too, except, of course, `chromium`.

if ! ( [ "$EUID" -eq 0 ] || SUDO_ASKPASS=/bin/false sudo -A /bin/true >/dev/null 2>&1) ; then

  echo 'Need `sudo`, or run as `root.'

else

  T_BEGIN=$(date +%s)

  sudo apt-get -y update
  sudo apt-get install -y git

  # TODO(dkorolev): The `Makefile` and a self-contained copy-pasteable command.
  # git clone https://github.com/dkorolev/dotfiles ~/.dotfiles

  ALL_APT_PACKAGES=""
  # TODO(dkorolev): have `#` comment until the EOL, not only if it's the first char of the line!
  for i in $(cat .dotfiles/apt-packages.txt | grep -v '^#'); do ALL_APT_PACKAGES="$ALL_APT_PACKAGES $i"; done

  time sudo apt-get install -y $ALL_APT_PACKAGES

  T_APT_DONE=$(date +%s)

  echo
  echo "APT packages installation took $((T_APT_DONE-T_BEGIN))s."
  echo

  # TODO(dkorolev): This did not work on an ARM.
  sudo mkdir -p /usr/lib/android-sdk/licenses
  sudo chmod a+rw  /usr/lib/android-sdk/licenses
  sudo mkdir -p /opt/android-sdk
  sudo chmod a+rw  /opt/android-sdk
  yes | sdkmanager --licenses

  # Install the dotfiles.
  cp $(find .dotfiles/ -maxdepth 1 -name '.*' -type f) .

  # Set the shell to `zsh`.
  sudo chsh -s $(which zsh) $(whoami)

  # Also, copy the dotfiles into `root`.
  for i in $(find .dotfiles/ -maxdepth 1 -name '.*' -type f) ; do sudo cp $i /root ; sudo chown root: /root/$i ; done

  git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/Valloric/YouCompleteMe ~/.vim/pack/plugins/opt/YouCompleteMe

  T_YCM_CLONE_DONE=$(date +%s)

  echo
  echo "YCM build took $((T_YCM_CLONE_DONE-T_APT_DONE))s."
  echo
  (cd ~/.vim/pack/plugins/opt/YouCompleteMe; ./install.py --all)

  T_YCM_DONE=$(date +%s)

  echo
  echo "YCM build took $((T_YCM_DONE-T_YCM_CLONE_DONE))s."
  echo

  T_DONE=$(date +%s)

  echo
  echo "Total setup time: $((T_DONE-T_BEGIN))s."
  echo

fi
