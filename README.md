# My Dotfiles

## Base Flow

## On a new system

Run:

```
sudo ./dkorolev_setup_system.sh
```

Among other things this makes sure the users from the `wheel` group have passwordless sudo.

Add those `wheel` users yourself, with `sudo usermod -a -G wheel USERNAME` for an existing `USERNAME`.

I've made the user `toor` to have a dedicated prompt with `zsh`, but the choice is ultimately yours.

## To add a user

First:

```
sudo adduser --encrypt-home {name}
sudo ./dkorolev_govern_user.sh {name}
```

Then log in as this user in Gnome and:

```
./dkorolev_setup_user.sh
```

## One-Liner for system setup

Requires `sudo`.

```
DIR=/tmp/.dotfiles.$(date +%s) &&
mkdir $DIR &&
(cd $DIR; wget df.dima.ai -O df.zip) &&
(cd $DIR; unzip df.zip) &&
$DIR/dotfiles-main/dkorolev_setup_system.sh &&
(rm -rf $DIR)
```

## One-Liner for user setup

Does not require `sudo`.

```
/var/dkorolev_dotfiles/dkorolev_setup_user.sh
```

## SSH

```
if [ -s ~/.ssh/id_ed25519.pub ] ; then echo "Already OK." ; else ssh-keygen -t ed25519 -C "$(whoami)-$(hostname)" ; fi
```

## GPG

```
gpg --list-secret-keys --keyid-format=long
```

## More

Please refer to the [NOTES](https://github.com/dkorolev/dotfiles/blob/main/NOTES.md) for deeper details.
