#!/bin/bash
#
# Must be run as root while the user is logged in so that their directory is not encrypted.

set -e

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

U=$1

if [ "$U" == "" ] ; then
  echo 'Need one argument: the username.'
  exit 1
fi

if [[ $UID == 0 || $EUID == 0 ]] ; then
  echo 'Please do not run as `root`.'
  exit 1
elif ! ( [ "$EUID" -eq 0 ] || SUDO_ASKPASS=/bin/false sudo -A /bin/true >/dev/null 2>&1) ; then
  echo 'Need `sudo`.'
  exit 1
fi

if sudo [ -f /home/dima/Access-Your-Private-Data.desktop ] ; then
  echo 'Need to log in as that user since their homedir is encrypted.'
  exit 1
fi

sudo "${SCRIPT_DIR}/chrome_default_profile_base_dir.sh" "$U"

sudo cat "/var/lib/AccountsService/users/$U" | grep '^Icon=' | sed "s/^Icon=//"

sudo runuser -u "$U" -- gsettings get org.gnome.desktop.background picture-uri  | xargs echo | sed 's/^file:\/\///'
