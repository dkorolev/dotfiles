alias ls='ls --color=auto'
alias jsb='js-beautify --indent-size=2 -n'

if [ "$WSL_DISTRO_NAME" != '' ] ; then
  alias xc='clip.exe'
else
  alias xc='xclip -selection clipboard'
fi

setopt histignorealldups sharehistory

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1~"   beginning-of-line
bindkey "^[[4~"   end-of-line

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
eval "$(dircolors -b)"
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

precmd() {
    vcs_info
}

# TODO(dkorolev): Use `#` instead of `$` when root.

setopt prompt_subst

prompt='[%F{grey}%m%f] %F{#0080ff}%d/%f ${vcs_info_msg_0_}$ '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
