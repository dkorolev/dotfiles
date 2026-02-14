# NOTE(dkorolev): Perhaps our "dotfiles installation" script could
# actually point to the dir to which this repo is cloned.
for f in ~/.*.shellrc; do
    [ -f "$f" ] && source "$f"
done
