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

## dk — Sandbox Dev Environment

`dk` SSHes into a remote machine (`ubu`) and sets up an isolated workspace with a zsh shell.

### Git repo passthrough

When you run `dk` from inside a clean git repo, the repo is automatically pushed to the remote:

1. `dk` creates a temporary bare repo on `ubu` with a random name (e.g. `ABCD-EFG-HIJK`).
2. It pushes your current branch and checks it out on the remote.
3. Your local `user.name` and `user.email` are forwarded to the remote repo.
4. You land in `~/ABCD-EFG-HIJK/` inside an SSH session.
5. Make commits as usual.
6. When you exit, `dk` fetches and fast-forward merges any new commits back into your local branch. If the merge is not a fast-forward, the remote is preserved for manual resolution.

If the host repo has uncommitted changes, `dk` refuses to start and lists what's dirty.

Running `dk` from a non-git directory gives a plain SSH session with no repo.

### Inside the sandbox

- The prompt shows a bold magenta `[SANDBOX]` prefix.
- The `INSIDE_DK_ENV` environment variable is set to `1`.
- The `c` alias runs `claude --dangerously-skip-permissions`.
- Running `dk` again from inside the sandbox is blocked (prints a warning).

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
