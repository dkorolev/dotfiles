alias ls='ls --color=auto'
alias jsb='js-beautify --indent-size=2 -n'

alias db='podman build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$(whoami) .'
alias dr='podman run --net host -e DISPLAY -it $(podman build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$(whoami) -q .)'
alias drx='xhost + && podman run --net host -e DISPLAY -it $(podman build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$(whoami) -q .)'

if [ "$WSL_DISTRO_NAME" != '' ] ; then
  alias xc='clip.exe'
else
  alias xc='xclip -selection clipboard'
fi

setopt histignorealldups sharehistory

# bindkey "^[[H"    beginning-of-line
# bindkey "^[[F"    end-of-line
# bindkey "^[[3~"   delete-char
# bindkey "^[[1;5D" backward-word
# bindkey "^[[1;5C" forward-word
# bindkey "^[[1~"   beginning-of-line
# bindkey "^[[4~"   end-of-line

# Do not make sounds on tab completion in WSL.
unsetopt beep

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.bash_zsh_history

autoload -Uz compinit && compinit -d ~/.cache/zsh/zcompdump
rm -f ~/.zcompdump

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# TODO(dkorolev): I'd love to have more Git integration, but `oh-my-zsh` looks too heavy to my taste.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "(%F{green}%b%f) "

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' actionformats '%b|%a %u%c'

precmd() {
  vcs_info && [[ -t 0 ]] && stty sane 2>/dev/null
}

setopt prompt_subst

if [[ $USER == "toor" ]] ; then
  prompt='[%F{red}%m%f] wheel %F{green}%%%f '
elif [[ $UID == 0 || $EUID == 0 ]] ; then
  prompt='[%F{red}%m%f] %d/ ${vcs_info_msg_0_}%F{red}#%f '
else
  prompt='[%F{grey}%m%f] %F{#0080ff}%d/%f ${vcs_info_msg_0_}$ '
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR=vim

# For `screen`.
bindkey '^R' history-incremental-search-backward

# For each terminal to have its own history!
unsetopt sharehistory

# I am doing Rust now! And this tab-completed file name is effing annoying, and it can't be renamed.
zstyle ':completion:*' ignored-patterns 'Cargo.lock'

# For `difftastic` to be used as `git difftool` on a Mac.
alias cls='osascript -e "tell application \"System Events\" to keystroke \"k\" using command down"'

alias d='git difftool'
alias gs='git status'
alias gp='git pull'
alias gl='git log'
alias ds='git diff --no-ext-diff'
alias dn='git diff --no-ext-diff --name-only'
alias wip='git add --all && git commit -m wip'
alias v='vim src/main.rs'
alias b='cargo build'
alias r='cargo run'
alias t='cargo test'
alias ft='cargo fmt'

alias tmx='/Users/dima/tmx.sh'

alias pls=/Users/dima/.local/bin/pls
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# TODO(dkorolev): Add `xs` for `xsel` on a Mac.

export LESS='-R --no-init --quit-if-one-screen'
