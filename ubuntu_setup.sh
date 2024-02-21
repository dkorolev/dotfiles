#!/bin/bash
#
# This script is meant to be run on a fresh Ubuntu installation.
#
# Friendly reminder. To add users later on:
# 1) [ with root ] sudo adduser --encrypt-home $U
# 2) [ with root ] sudo ./govern_user.sh $U
# 3) [  as user ]  ./setup_user.sh

set -e

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

if [[ $UID == 0 || $EUID == 0 ]] ; then
  echo 'Please do not run as `root`.'
  exit 1
elif ! ( [ "$EUID" -eq 0 ] || SUDO_ASKPASS=/bin/false sudo -A /bin/true >/dev/null 2>&1) ; then
  echo 'Need `sudo`.'
  exit 1
fi

ARCH=$(arch)

T_BEGIN=$(date +%s)

sudo apt-get -y update
sudo apt-get install -y git

ALL_APT_PACKAGES=""
# TODO(dkorolev): have `#` comment until the EOL, not only if it's the first char of the line!
for i in $(cat "${SCRIPT_DIR}/apt-packages.txt" | grep -v '^#'); do
  # TODO(dkorolev): Make this more generic, i.e. some `sdkmanager  # arch-disable:aarch64` in `apt-packages.txt`.'
  if [ "$ARCH" != "aarch64" ] || [ "$i" != "sdkmanager" ] ; then
    ALL_APT_PACKAGES="$ALL_APT_PACKAGES $i"
  fi
done

time sudo apt-get install -y $ALL_APT_PACKAGES

T_APT_DONE=$(date +%s)

echo
echo "APT packages installation took $((T_APT_DONE-T_BEGIN))s."
echo

if [ "$ARCH" != "aarch64" ] ; then
  sudo mkdir -p /usr/lib/android-sdk/licenses
  sudo chmod a+rw  /usr/lib/android-sdk/licenses
  sudo mkdir -p /opt/android-sdk
  sudo chmod a+rw  /opt/android-sdk
  yes | sdkmanager --licenses
fi

# Install the dotfiles.
cp $(find "${SCRIPT_DIR}/" -maxdepth 1 -name '.*' -type f) ~

# Save this repo for future users.
sudo rm -rf /var/dotfiles
sudo cp -R "${SCRIPT_DIR}" /var/dotfiles
sudo chmod -R a-w /var/dotfiles

# Set the shell to `zsh`.
sudo cp /etc/pam.d/chsh /etc/pam.d/chsh.save
sudo sed -i s/required/sufficient/g /etc/pam.d/chsh
sudo chsh -s $(which zsh) $(whoami)
sudo mv /etc/pam.d/chsh.save /etc/pam.d/chsh

# Also, copy the dotfiles into `root`, for the `sudo` shell to be beautified too.
for i in $(find /var/dotfiles/ -maxdepth 1 -name '.*' -type f) ; do sudo cp $i /root ; sudo chown root: /root/$(basename $i) ; done

# No gnome initial setup for each and every new user.
sudo mkdir -p /etc/skel/.config
echo yes | sudo tee /etc/skel/.config/gnome-initial-setup-done >/dev/null

# Prepare the `wheel` group.
sudo addgroup wheel >/dev/null 2>&1 && echo 'Group `wheel` created.' || echo 'Group `wheel` already exists.'
sudo cat /etc/sudoers | grep 'editor=' >/dev/null && echo 'Already using `vim` for `visuso`.' || echo 'Defaults editor=/usr/bin/vim' | sudo tee -a /etc/sudoers >/dev/null
sudo cat /etc/sudoers | grep NOPASSWD >/dev/null && echo 'Already has `NOPASSWD` for `wheel`.' || echo '%wheel ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers >/dev/null

# NOTE(dkorolev): Not adding sudo-friendly users here, as this is super private, and should not be part of the repo.

T_DONE=$(date +%s)

echo
echo "Total setup time: $((T_DONE-T_BEGIN))s."
echo
