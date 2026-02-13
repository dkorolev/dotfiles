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

exec su-exec "$DK_USER" /bin/zsh -l
