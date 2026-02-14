#!/bin/bash
set -euo pipefail

# Not in a git repo — just ssh in.
if ! repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
  exec ssh ubu
fi

# In a git repo — require a clean working tree.
dirty=$(git -C "$repo_root" status --porcelain)
if [ -n "$dirty" ]; then
  echo "Error: git repo has uncommitted changes:"
  echo "$dirty"
  exit 1
fi

DK_BRANCH="$(git -C "$repo_root" rev-parse --abbrev-ref HEAD)"

# Generate a random name in ABCD-EFG-HIJK format.
REMOTE_DIR=$(LC_ALL=C tr -dc 'A-Z' < /dev/urandom | head -c 11 | sed 's/\(.\{4\}\)\(.\{3\}\)\(.\{4\}\)/\1-\2-\3/')
REMOTE_LABEL="ubu-$REMOTE_DIR"

# Create a repo on ubu and push to it.
ssh ubu "git init --quiet '$REMOTE_DIR'"
git -C "$repo_root" remote add "$REMOTE_LABEL" "ubu:$REMOTE_DIR"
git -C "$repo_root" push --quiet "$REMOTE_LABEL" "$DK_BRANCH"
ssh ubu "git -C '$REMOTE_DIR' checkout --quiet '$DK_BRANCH'"

echo "Pushed $DK_BRANCH → ubu:~/$REMOTE_DIR ($REMOTE_LABEL)"

# SSH into ubu, landing in the repo directory.
ssh -t ubu "cd '$REMOTE_DIR' && exec \$SHELL -l" || true

# After exiting: pull changes back.
echo ""
git -C "$repo_root" fetch --quiet "$REMOTE_LABEL" "$DK_BRANCH"

local_head=$(git -C "$repo_root" rev-parse HEAD)
fetched_head=$(git -C "$repo_root" rev-parse FETCH_HEAD)

if [ "$local_head" = "$fetched_head" ]; then
  git -C "$repo_root" remote remove "$REMOTE_LABEL"
  ssh ubu "rm -rf '$REMOTE_DIR'"
  exit 0
fi

if git -C "$repo_root" merge --ff-only FETCH_HEAD; then
  git -C "$repo_root" remote remove "$REMOTE_LABEL"
  ssh ubu "rm -rf '$REMOTE_DIR'"
else
  echo "Could not fast-forward. Remote '$REMOTE_LABEL' preserved."
fi
