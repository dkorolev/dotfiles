# My Dotfiles

## Base Flow

### On a new system

Run:

```
sudo ./ubuntu_setup.sh
```

Among other things this makes sure the users from the `wheel` group have passwordless sudo.

Add those `wheel` users yourself, with `sudo usermod -a -G wheel USERNAME` for an existing `USERNAME`.

I've made the user `toor` to have a dedicated prompt with `zsh`, but the choice is ultimately yours.

### To add a user

First:

```
sudo adduser --encrypt-home {name}
sudo ./govern_user.sh {name}
```

Log in as this user in Gnome. In there:

* Launch Chromium.
  * This creates its config dir.
* Close Chromium and start it again.
  * This offers to set it as the default browser.
  * Pin it to the dash is wanted.
* Close Chromium.

Then run:

```
./setup_user.sh
```

This should configure the Chromium profile, plus set the wallpaper and the profile pic, plus unpack user-specific files.

Done!

### Quick way to grab this repo.

```
wget df.dima.ai -O df.zip && unzip df.zip && mv dotfiles-main dotfiles
```

## dk — Docker Dev Container

`dk` launches an ephemeral Docker container with your user identity and a zsh shell.

### Git repo passthrough

When you run `dk` from inside a clean git repo, the repo is automatically available inside the container:

1. `dk` clones your current branch into `.dk.tmp/upstream` and starts the container.
2. Inside the container you land in `/app/<repo-name>/` — this is the clone.
3. Make commits as usual.
4. When you exit the container, `dk` detects new commits and prompts:
   ```
   Pull changes from dk container into <repo-name>? [Y/n]
   ```
   Pressing Enter (default: yes) fast-forward merges the changes into your host branch.

If the host repo has uncommitted changes, `dk` refuses to start and lists what's dirty.

Running `dk` from a non-git directory gives a plain container with no repo.

## Useful Commands

### SSH

```
if [ -s ~/.ssh/id_ed25519.pub ] ; then echo "Already OK." ; else ssh-keygen -t ed25519 -C "$(whoami)-$(hostname)" ; fi
```

### GPG

```
gpg --list-secret-keys --keyid-format=long
```

### More

Please refer to the [NOTES](https://github.com/dkorolev/dotfiles/blob/main/NOTES.md) for deeper details.
