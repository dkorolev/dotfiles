# My Dotfiles

## One-Liner for system setup

Requires `sudo`.

```
DIR=/tmp/.dotfiles.$(date +%s) && \
mkdir $DIR && \
(cd $DIR; wget df.dima.ai -O df.zip) &&
(cd $DIR; unzip df.zip) &&
./$DIR/dotfiles-main/dkorolev_setup_system.sh &&
(rm -rf $DIR)
```

## One-Liner for user setup

Does not require `sudo`.

```
DIR=/tmp/.dotfiles.$(date +%s) && \
mkdir $DIR && \
(cd $DIR; wget df.dima.ai -O df.zip) &&
(cd $DIR; unzip df.zip) &&
./$DIR/dotfiles-main/dkorolev_setup_user.sh &&
(rm -rf $DIR)
```

## More

Please refer to the [NOTES](https://github.com/dkorolev/dotfiles/blob/main/NOTES.md) for deeper details.
