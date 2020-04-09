#!/usr/bin/env zsh

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history hist_ignore_all_dups histignorespace
# Misc options
setopt auto_list
setopt auto_param_keys
setopt auto_param_slash
setopt extendedglob
setopt hash_cmds
setopt hash_dirs
setopt numeric_glob_sort
setopt transient_rprompt
unsetopt beep
unsetopt notify
# Color vars
autoload -U colors
colors
# Watch for login/logout
watch=all
# umask
umask 0022

# vi keybindings
bindkey -v
# Edit cmdline
autoload edit-command-line
zle -N edit-command-line
bindkey 'e' edit-command-line
bindkey 'x' execute-named-cmd

# Complete help
bindkey 'c' _complete_help
bindkey '^R' history-incremental-pattern-search-backward
# parenthesis, quotes, etc.
bindkey -s '((' '()\ei'
bindkey -s '( (' '(   )\ehhi'
bindkey -s '(((' '(\ea(   ))\ehhhi'
bindkey -s '{{' '{}\ei'
bindkey -s '{ {' '{  }\ehi'
bindkey -s '{{{' '{\ea{   }}\ehhhi' # }}} (quick and ugly folding fix...)
bindkey -s '[[' '[]\ei'
bindkey -s '[ [' '[   ]\ehhi'
bindkey -s '[[[' '[\ea[   ]]\ehhhi'
bindkey -s "''" "'\ea'\ei"
bindkey -s '""' '"\ea"\ei'
# Completion
autoload -Uz compinit
autoload -Uz complist
compinit
zstyle ':completion:*' menu select=5
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' max-errors 2 not-numeric
zstyle ':completion:*:approximate:::' max-errors 3 numeric
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' original true
zstyle ':completion:*' squeeze-slashes true
# disable START / STOP and get C-s / C-q back
stty -ixon &>/dev/null

# Per OS settings
function is_a_BSD() {
    alias ll="ls -loh"
    alias lla="ls -lohA"
    # GNU/ls like colors (used by zsh completion)
    export LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz'
}

# used if the toor user exist
function has_toor() {
    alias toor="sudo su -l toor"
}

function maybe_colorls() {
    if command -v colorls >/dev/null; then
        alias ls="colorls -G"
        alias ll="colorls -Glo"
        alias la="colorls -GA"
        alias lla="colorls -GloA"
    fi
}

function lscolors() {
    # FreeBSD's ls colors (default is "exfxcxdxbxegedabagacad")
    export LSCOLORS='ExGxFxcxCxdxdxhbadacec'
    export CLICOLOR='enable'
}

function gnu_grep() {
    alias grep="grep --color=auto"
}

case `uname -s` in
  NetBSD)
    is_a_BSD; has_toor; maybe_colorls
  ;;
  FreeBSD|DragonFly)
    is_a_BSD; has_toor; lscolors; gnu_grep
  ;;
  OpenBSD)
    is_a_BSD; maybe_colorls
    alias realpath="/usr/bin/readlink -f"
    alias sudo=doas
  ;;
  Linux)
    gnu_grep
    if [[ -r ~/.dir_colors ]]; then
      eval `dircolors -b ~/.dir_colors`
    elif [[ -r /etc/DIR_COLORS ]]; then
      eval `dircolors -b /etc/DIR_COLORS`
    else
      eval `dircolors`
    fi
    # disable GNU coreutil trolling
    export QUOTING_STYLE=literal
    # GNU ls colors
    alias ls="ls --color=auto"
    alias ll="ls -lhF"
    alias lla="ls -lhAF"
  ;;
  Darwin) # *khof*
    is_a_BSD; lscolors; gnu_grep
  ;;
esac
unfunction is_a_BSD has_toor maybe_colorls lscolors gnu_grep

# Completion II
zmodload -a autocomplete
zmodload -a complist
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "${fg_bold[yellow]}%B%d%b$end"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*' group-name ''
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:cd:*' tag-order local-directories path-directories
# color for completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# menu for auto-completion
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# Completion Menu for kill
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:*:kill:*' menu yes select
# Cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
# failed match * are passed literally
#unsetopt nomatch
if command -v kubectl >/dev/null; then
    source <(kubectl completion zsh)
fi

# General aliases
alias la="ls -A"
alias :q="exit"
alias tmux="tmux -2 -u"
alias less="less -Rc"
alias cdtmp='cd "$(mktemp -d)"'
# fzf
[ -d ~/.local/fzf/bin ] && export PATH="$HOME/.local/fzf/bin:$PATH"
if command -v fzf >/dev/null; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --multi'
    if command -v bat >/dev/null; then
        export BAT_THEME="Gruvbox-N"
        export FZF_COMPLETION_OPTS="--preview-window=60% --preview 'bat --style=numbers --color=always {}'"
        export FZF_CTRL_T_OPTS="$FZF_COMPLETION_OPTS"
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    fi
    [ -f ~/.local/fzf/shell/completion.zsh ] && source ~/.local/fzf/shell/completion.zsh
    [ -f ~/.local/fzf/shell/key-bindings.zsh ] && source ~/.local/fzf/shell/key-bindings.zsh
fi

# use personal lesspipe.sh if avaiable
if [ -f ~/.local/bin/lesspipe.sh ]; then
    export LESSOPEN="| ~/.local/bin/lesspipe.sh %s"
fi

# Prompts
PS2="%{$fg_no_bold[yellow]%}%_>%{${reset_color}%} "
PS3="%{$fg_no_bold[yellow]%}?#%{${reset_color}%} "

# Display the title
function title {
  local t="%n@%m %~"

  case $TERM in
    screen*) # and tmux
      print -nP "\ek$t\e\\"
      print -nP "\e]0;$t\a"
      ;;
    xterm*|rxvt*|(E|e)term)
      print -nP "\e]0;$t\a"
      ;;
  esac
}

# PS1 setup
function precmd {
  # Set window title
  title

  # Color for non-text things
  local misc="%{${fg_bold[black]}%}"

  # Change path color given user rights on it
  if [[ -w "${PWD}" ]]; then # can write
    local path_color="${fg_bold[blue]}"
  else # other
    local path_color="${fg_bold[red]}"
  fi

  if [[ $UID = 0 ]]; then
    local login_color="${fg_bold[red]}"
  else
    local login_color="${fg_bold[white]}"
  fi

  # host color.
  local host_color="${fg_bold[yellow]}"

  # Display return code when not 0
  local return_code="%(?..${misc}!%{${fg_bold[red]}%}%?${misc} )"
  # Host
  local host="%{${host_color}%}%M"
  # User
  local user="${misc}%{${login_color}%}%n${misc}"
  # Current path
  local cwd="%{${path_color}%}%48<...<%~"
  # % for user, # for root.
  local sign="%{${misc}%}%#"

  # Set the prompt
  PS1="${return_code}${user}@${host} ${cwd} ${sign}%{${reset_color}%} "
}

# Reminder
[ -f ~/.reminder ] && cat ~/.reminder

# More zsh config
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

: # noop

# vim:filetype=zsh:tabstop=2:shiftwidth=2:fdm=marker:
