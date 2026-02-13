#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

mkdir -p "$SCRIPT_DIR/.dk.tmp"

# Detect if we're inside a git repo.
DK_REPO_ROOT=""
DK_REPO_NAME=""
DK_BRANCH=""
if repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
  dirty=$(git -C "$repo_root" status --porcelain)
  if [ -n "$dirty" ]; then
    echo "Error: git repo has uncommitted changes:"
    echo "$dirty"
    exit 1
  fi
  DK_REPO_ROOT="$repo_root"
  DK_REPO_NAME="$(basename "$repo_root")"
  DK_BRANCH="$(git -C "$repo_root" rev-parse --abbrev-ref HEAD)"
  DK_GIT_USER_NAME="$(git config user.name || true)"
  DK_GIT_USER_EMAIL="$(git config user.email || true)"
  rm -rf "$SCRIPT_DIR/.dk.tmp/upstream"
  git clone --quiet --single-branch --branch "$DK_BRANCH" "$DK_REPO_ROOT" "$SCRIPT_DIR/.dk.tmp/upstream"
fi

if ! (cd "$SCRIPT_DIR/docker/dk"; make -q) ; then
  echo 'Rebuilding the container.'
  (cd "$SCRIPT_DIR/docker/dk"; make >/dev/null)
  echo 'Rebuilt successful.'
fi

docker run -it --hostname dk \
  -v "$SCRIPT_DIR/.dk.tmp:/tmp" \
  -e DK_UID="$(id -u)" \
  -e DK_GID="$(id -g)" \
  -e DK_USER="$(whoami)" \
  ${DK_REPO_NAME:+-e "DK_REPO_NAME=$DK_REPO_NAME"} \
  ${DK_GIT_USER_NAME:+-e "DK_GIT_USER_NAME=$DK_GIT_USER_NAME"} \
  ${DK_GIT_USER_EMAIL:+-e "DK_GIT_USER_EMAIL=$DK_GIT_USER_EMAIL"} \
  $(cat "$SCRIPT_DIR/docker/dk/tag")

# After the container exits, offer to merge changes back.
if [ -n "$DK_REPO_ROOT" ] && [ -d "$SCRIPT_DIR/.dk.tmp/upstream" ]; then
  local_head=$(git -C "$DK_REPO_ROOT" rev-parse HEAD)
  upstream_head=$(git -C "$SCRIPT_DIR/.dk.tmp/upstream" rev-parse "refs/heads/$DK_BRANCH" 2>/dev/null || true)
  if [ -n "$upstream_head" ] && [ "$local_head" != "$upstream_head" ]; then
    read -rp "Pull changes from dk container into $DK_REPO_NAME? [Y/n] " answer
    if [ -z "$answer" ] || [[ "$answer" =~ ^[Yy] ]]; then
      git -C "$DK_REPO_ROOT" fetch "$SCRIPT_DIR/.dk.tmp/upstream" "$DK_BRANCH"
      git -C "$DK_REPO_ROOT" merge --ff-only FETCH_HEAD
    fi
  fi
fi
