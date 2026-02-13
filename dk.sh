#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

if ! (cd "$SCRIPT_DIR/docker/dk"; make -q) ; then
  echo 'Rebuilding the container.'
  (cd "$SCRIPT_DIR/docker/dk"; make >/dev/null)
  echo 'Rebuilt successful.'
fi
docker run -it $(cat "$SCRIPT_DIR/docker/dk/tag")
