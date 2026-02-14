#!/bin/sh
set -e

: "${DK_UID:=1000}" "${DK_GID:=1000}" "${DK_USER:=user}"
home="/app"

# Reuse existing group for this GID, or create one
group=$(awk -F: -v g="$DK_GID" '$3==g{print $1; exit}' /etc/group)
if [ -z "$group" ]; then
  groupadd --gid "$DK_GID" "$DK_USER"
  group="$DK_USER"
fi

# Create the user with /app as home.
mkdir -p "$home"
if ! id "$DK_USER" >/dev/null 2>&1; then
  useradd -K UID_MIN=500 --uid "$DK_UID" --gid "$group" --shell /bin/zsh --home-dir "$home" --no-create-home "$DK_USER"
fi

cp /etc/skel/.zshrc /etc/skel/.dima.shellrc "$home/"
echo "alias dk='echo \"\033[35mCOLORBLIND I GUESS?\033[0m\"'" >> "$home/.zshrc"
echo "alias c='claude --dangerously-skip-permissions'" >> "$home/.zshrc"
mkdir -p "$home/.cache/zsh"

# Configure git: difftastic and user identity.
gc="$home/.gitconfig"
git config -f "$gc" diff.external difft
[ -n "${DK_GIT_USER_NAME:-}" ] && git config -f "$gc" user.name "$DK_GIT_USER_NAME"
[ -n "${DK_GIT_USER_EMAIL:-}" ] && git config -f "$gc" user.email "$DK_GIT_USER_EMAIL"

# If a repo was passed through, symlink it into /app.
workdir="$home"
if [ -n "${DK_REPO_NAME:-}" ] && [ -d /tmp/upstream ]; then
  ln -s /tmp/upstream "$home/$DK_REPO_NAME"
  workdir="$home/$DK_REPO_NAME"
fi

chown -R "$DK_UID:$DK_GID" "$home"

exec gosu "$DK_USER" /bin/sh -c "cd '$workdir' && exec /bin/zsh -l"
