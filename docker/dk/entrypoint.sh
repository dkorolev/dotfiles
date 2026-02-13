#!/bin/sh
set -e

: "${DK_UID:=1000}" "${DK_GID:=1000}" "${DK_USER:=user}"
home="/home/$DK_USER"

# Reuse existing group for this GID, or create one
group=$(awk -F: -v g="$DK_GID" '$3==g{print $1; exit}' /etc/group)
if [ -z "$group" ]; then
  addgroup -g "$DK_GID" "$DK_USER"
  group="$DK_USER"
fi

# Create the user with matching UID
if ! id "$DK_USER" >/dev/null 2>&1; then
  adduser -D -u "$DK_UID" -G "$group" -s /bin/zsh -h "$home" "$DK_USER"
fi

cp /etc/skel/.zshrc /etc/skel/.dima.shellrc "$home/"
mkdir -p "$home/.cache/zsh"
chown -R "$DK_UID:$DK_GID" "$home"

# Configure git: difftastic and user identity.
gc="$home/.gitconfig"
git config -f "$gc" diff.external difft
[ -n "${DK_GIT_USER_NAME:-}" ] && git config -f "$gc" user.name "$DK_GIT_USER_NAME"
[ -n "${DK_GIT_USER_EMAIL:-}" ] && git config -f "$gc" user.email "$DK_GIT_USER_EMAIL"
chown "$DK_UID:$DK_GID" "$gc"

# Start in /app; if a repo was passed through, symlink it there.
mkdir -p /app
workdir="/app"
if [ -n "${DK_REPO_NAME:-}" ] && [ -d /tmp/upstream ]; then
  ln -s /tmp/upstream "/app/$DK_REPO_NAME"
  workdir="/app/$DK_REPO_NAME"
fi

exec su-exec "$DK_USER" /bin/sh -c "cd '$workdir' && exec /bin/zsh -l"
