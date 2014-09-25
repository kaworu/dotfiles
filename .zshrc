#!/usr/bin/env zsh
# my zshrc

# {{{ General settings

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history hist_ignore_all_dups

# Misc options
setopt auto_list
setopt auto_param_keys
setopt auto_param_slash
setopt autocd
setopt equals
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

# }}}

# {{{ Keybindings

# vi keybindings
bindkey -v

# Fixes from Debian
if [[ "$TERM" != emacs ]]; then
  [[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
  [[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
  [[ -z "$terminfo[kend]" ]] || bindkey -M emacs "$terminfo[kend]" end-of-line
  [[ -z "$terminfo[kich1]" ]] || bindkey -M emacs "$terminfo[kich1]" overwrite-mode
  [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
  [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
  [[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
  [[ -z "$terminfo[kich1]" ]] || bindkey -M vicmd "$terminfo[kich1]" overwrite-mode

  # [[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" vi-up-line-or-history
  [[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" up-line-or-history
  [[ -z "$terminfo[cuf1]" ]] || bindkey -M viins "$terminfo[cuf1]" vi-forward-char
  # [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
  [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
  # [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
  [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history
  [[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
  [[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char

  # ncurses fogyatekos
  # [[ "$terminfo[kcuu1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
  # [[ "$terminfo[kcud1]" == "O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
  [[ "$terminfo[kcuu1]" == ""* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
  [[ "$terminfo[kcud1]" == ""* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history
  [[ "$terminfo[kcuf1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
  [[ "$terminfo[kcub1]" == "O"* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
  [[ "$terminfo[khome]" == "O"* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
  [[ "$terminfo[kend]" == "O"* ]] && bindkey -M viins "${terminfo[kend]/O/[}" end-of-line
  [[ "$terminfo[khome]" == "O"* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
  [[ "$terminfo[kend]" == "O"* ]] && bindkey -M emacs "${terminfo[kend]/O/[}" end-of-line
fi

# URxvt keys
bindkey '[2~' overwrite-mode
bindkey '[3~' delete-char
bindkey '[7~' beginning-of-line
bindkey '[8~' end-of-line
bindkey '[5~' history-search-backward
bindkey '[6~' history-search-forward

# Man
#bindkey 'h' run-help

# Edit cmdline
autoload edit-command-line
zle -N edit-command-line
bindkey 'e' edit-command-line
bindkey 'x' execute-named-cmd

# Complete help
bindkey 'c' _complete_help

bindkey '^R' history-incremental-search-backward

# () [] {} ...
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

# }}}

# {{{ Completion

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

# }}}

# {{{ Per OS settings

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

case `uname -s` in
  NetBSD)
    is_a_BSD; has_toor
    if which colorls &>/dev/null; then
      alias cls="colorls -G"
      alias cll="colorls -Glo"
      alias cla="colorls -GA"
      alias clla="colorls -GloA"
    fi
  ;;
  FreeBSD|DragonFly)
    is_a_BSD; has_toor
    # FreeBSD's ls colors (default is "exfxcxdxbxegedabagacad")
    export LSCOLORS='ExGxFxcxCxdxdxhbadacec'
    export CLICOLOR='enable'
    alias grep="grep --color=auto" # GNU grep
  ;;
  OpenBSD)
    is_a_BSD
    # FIXME: hardcoded 4.4
    export PKG_PATH=http://mirror.switch.ch/ftp/pub/OpenBSD/4.4/packages/${$(arch)/OpenBSD\.}
  ;;
  Linux)
    if [[ -r ~/.dir_colors ]]; then
      eval `dircolors -b ~/.dir_colors`
    elif [[ -r /etc/DIR_COLORS ]]; then
      eval `dircolors -b /etc/DIR_COLORS`
    else
      eval `dircolors`
    fi
    # GNU ls colors
    alias ls="ls --color=auto"
    alias ll="ls -lhF"
    alias lla="ls -lhAF"
    # try to buy some real useful stuff
    alias realpath="/bin/readlink -f"
    alias grep="grep --color=auto" # GNU grep
  ;;
  Darwin) # *khof*
    is_a_BSD
  ;;
esac

unfunction is_a_BSD has_toor
# }}}

# {{{ Completion II
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
#zstyle ':completion:*:processes' command 'ps -u'
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:*:kill:*' menu yes select
#zstyle ':completion:*:*:kill:*' force-list always
# Cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache

# failed match * are passed literally
#unsetopt nomatch
# }}}

# {{{ General aliases

# vim as manpager when avaiable.
which vimmanpager &>/dev/null && alias man="man -P vimmanpager"
alias la="ls -A"
alias :q="exit"
# use personal lesspipe.sh if avaiable
alias less="less -Rc"
if [ -f ~/.local/bin/lesspipe.sh ]; then
    export LESSOPEN="| ~/.local/bin/lesspipe.sh %s"
fi

# }}}

# {{{ Prompts

# Right prompt with clock
#RPS1="  %{$fg_no_bold[yellow]%}%D{%d/%m/%y %H:%M:%S}%{${reset_color}%}"

# Others prompts
PS2="%{$fg_no_bold[yellow]%}%_>%{${reset_color}%} "
PS3="%{$fg_no_bold[yellow]%}?#%{${reset_color}%} "

# }}}

# {{{ title()

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

# }}}

# {{{ precmd()

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
  local host_color="${fg_bold[white]}"

  # Jailed ?
  if [[ "`uname -s`" = 'FreeBSD' && "`sysctl -n security.jail.jailed 2>/dev/null`" = 1 ]]; then
    local jailed="${misc}(%{${fg_no_bold[yellow]}%}jail${misc})"
  else
    local jailed=""
  fi
  # Display return code when not 0
  local return_code="%(?..${misc}!%{${fg_bold[red]}%}%?${misc}! )"
  # Host
  local host="%{${host_color}%}%M"
  # User
  local user="${misc}%{${login_color}%}%n${misc}"
  # Current path
  local cwd="%{${path_color}%}%48<...<%~"
  # % for user, # for root.
  local sign="%{${misc}%}%#"

  # Set the prompt
  PS1="${return_code}${misc}[${user}@${host}${jailed} ${cwd}${misc}] ${sign}%{${reset_color}%} "
}

# }}}

# {{{ run-help-sudo

function run-help-sudo {
  if [ $# -eq 0 ]; then
    man sudo
  else
    man $1
  fi
}

# }}}

# {{{ Reminder

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if [[ -f ~/.reminder ]]; then
  cat ~/.reminder
fi

# }}}

: # noop

# vim:filetype=zsh:tabstop=2:shiftwidth=2:fdm=marker:
