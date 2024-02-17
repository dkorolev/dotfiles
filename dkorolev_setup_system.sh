#!/bin/bash
#
# This script is meant to be run on a fresh Ubuntu installation.
#
# Friendly reminders:
# 1) Run `./dkorolev_setup_user.sh` for each newly created user.
# 2) The recommended way to create users is `sudo adduser --encrypt-home {DESIRED_USERNAME}`.
#
# Tested under WSL too, except, of course, `chromium`.

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

if [[ $UID == 0 || $EUID == 0 ]] ; then
  echo 'Please do not run as `root`.'
  exit 1
elif ! ( [ "$EUID" -eq 0 ] || SUDO_ASKPASS=/bin/false sudo -A /bin/true >/dev/null 2>&1) ; then
  echo 'Need `sudo`.'
  exit 1
fi

T_BEGIN=$(date +%s)

sudo apt-get -y update
sudo apt-get install -y git

# TODO(dkorolev): The `Makefile` and a self-contained copy-pasteable command.
# git clone https://github.com/dkorolev/dotfiles ~/.dotfiles

ALL_APT_PACKAGES=""
# TODO(dkorolev): have `#` comment until the EOL, not only if it's the first char of the line!
for i in $(cat "${SCRIPT_DIR}/apt-packages.txt" | grep -v '^#'); do ALL_APT_PACKAGES="$ALL_APT_PACKAGES $i"; done

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
cp $(find "${SCRIPT_DIR}/" -maxdepth 1 -name '.*' -type f) .

# Save the dotfiles for future users.
sudo mkdir -p /var/dotfiles
sudo chmod a+rw /var/dotfiles
cp $(find "${SCRIPT_DIR}" -maxdepth 1 -name '.*' -type f) /var/dotfiles
sudo chmod a-w /var/dotfiles

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

T_DONE=$(date +%s)

echo
echo "Total setup time: $((T_DONE-T_BEGIN))s."
echo
