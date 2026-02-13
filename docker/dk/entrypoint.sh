#!/bin/sh
set -e

: "${DK_UID:=1000}" "${DK_GID:=1000}" "${DK_USER:=user}"
home="/home/$DK_USER"

# Ensure a group with the right GID exists
if ! awk -F: -v g="$DK_GID" '$3==g{exit 0} END{exit 1}' /etc/group 2>/dev/null; then
  addgroup -g "$DK_GID" "$DK_USER"
fi
group=$(awk -F: -v g="$DK_GID" '$3==g{print $1; exit}' /etc/group)

# Create the user with matching UID
if ! id "$DK_USER" >/dev/null 2>&1; then
  adduser -D -u "$DK_UID" -G "$group" -s /bin/zsh -h "$home" "$DK_USER"
fi

cp /etc/skel/.zshrc /etc/skel/.dima.shellrc "$home/"
mkdir -p "$home/.cache/zsh"
chown -R "$DK_UID:$DK_GID" "$home"

exec su-exec "$DK_USER" /bin/zsh -l
