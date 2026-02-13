#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
DK_TMP="$(pwd)/.dk.tmp"

mkdir -p "$DK_TMP"

# Detect if we're inside a git repo.
DK_REPO_ROOT=""
DK_REPO_NAME=""
DK_BRANCH=""
if repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
  DK_TMP="$repo_root/.dk.tmp"
  mkdir -p "$DK_TMP"

  # Require .dk.tmp to be gitignored (committed) before proceeding.
  if ! git -C "$repo_root" check-ignore -q .dk.tmp 2>/dev/null; then
    echo "Error: .dk.tmp/ must be gitignored before dk can run."
    echo ""
    echo "  echo '.dk.tmp/' >> $repo_root/.gitignore"
    echo "  git add $repo_root/.gitignore && git commit -m 'Gitignore .dk.tmp/'"
    echo ""
    echo "Then re-run dk."
    exit 1
  fi

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
  rm -rf "$DK_TMP/upstream"
  git clone --quiet --single-branch --branch "$DK_BRANCH" "$DK_REPO_ROOT" "$DK_TMP/upstream"
fi

if ! (cd "$SCRIPT_DIR/docker/dk"; make -q) ; then
  echo 'Rebuilding the container.'
  (cd "$SCRIPT_DIR/docker/dk"; make >/dev/null)
  echo 'Rebuilt successful.'
fi

if [ -f "$HOME/.dk.claude_key" ]; then
  cp "$HOME/.dk.claude_key" "$DK_TMP/dk.claude_key"
else
  rm -f "$DK_TMP/dk.claude_key"
  echo ""
  echo "Claude is not configured for dk. To set it up, run \`claude\` inside"
  echo "the container, authenticate, then run \`save_claude_dk_setup\` to save."
  echo ""
fi

docker run -it --hostname dk \
  -v "$DK_TMP:/tmp" \
  -e DK_UID="$(id -u)" \
  -e DK_GID="$(id -g)" \
  -e DK_USER="$(whoami)" \
  -e DK_SANDBOX=1 \
  ${DK_REPO_NAME:+-e "DK_REPO_NAME=$DK_REPO_NAME"} \
  ${DK_GIT_USER_NAME:+-e "DK_GIT_USER_NAME=$DK_GIT_USER_NAME"} \
  ${DK_GIT_USER_EMAIL:+-e "DK_GIT_USER_EMAIL=$DK_GIT_USER_EMAIL"} \
  $(cat "$SCRIPT_DIR/docker/dk/tag")

# After the container exits, check for saved Claude config.
if [ -f "$DK_TMP/update.dk.claude_key" ]; then
  if [ ! -f "$HOME/.dk.claude_key" ]; then
    mv "$DK_TMP/update.dk.claude_key" "$HOME/.dk.claude_key"
    echo "Claude config saved to ~/.dk.claude_key."
  else
    echo "~/.dk.claude_key already exists. To overwrite:"
    echo "  mv $DK_TMP/update.dk.claude_key ~/.dk.claude_key"
  fi
fi

# After the container exits, offer to merge changes back.
if [ -n "$DK_REPO_ROOT" ] && [ -d "$DK_TMP/upstream" ]; then
  local_head=$(git -C "$DK_REPO_ROOT" rev-parse HEAD)
  upstream_head=$(git -C "$DK_TMP/upstream" rev-parse "refs/heads/$DK_BRANCH" 2>/dev/null || true)
  if [ -n "$upstream_head" ] && [ "$local_head" != "$upstream_head" ]; then
    read -rp "Pull changes from dk container into $DK_REPO_NAME? [Y/n] " answer
    if [ -z "$answer" ] || [[ "$answer" =~ ^[Yy] ]]; then
      git -C "$DK_REPO_ROOT" fetch "$DK_TMP/upstream" "$DK_BRANCH"
      git -C "$DK_REPO_ROOT" merge --ff-only FETCH_HEAD
    fi
  fi
fi
