# Bash configuration, for sucky GNU OSes without zsh or ksh

# {{{ Initial check, because bash is not enough good to not read this file when non interactive...

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# }}}

# {{{ General settings

# History
HISTFILE=~/.histfile
HISTFILESIZE=5000
HISTSIZE=5000
HISTCONTROL=ignoredups
shopt -s histappend
shopt -s cmdhist

# Check window size after each command
shopt -s checkwinsize

# Error if glob fail
# Seems buggy, as usual...
# shopt -s failglob

# vi mode, not as perfect as on zsh, but still better...
# set -o vi

# }}}

# {{{ Aliases

case `uname -s` in
  FreeBSD)
    export LSCOLORS="exgxfxcxcxdxdxhbadacec"
    alias ls="ls -G"
    alias ll="ls -h -l"
    alias la="ls -a"
    alias grep="grep --color=auto"
    alias egrep="egrep --color=auto"
    ;;
  Linux)
    if [[ -r ~/.dir_colors ]]; then
      eval `dircolors -b ~/.dir_colors`
    elif [[ -r /etc/DIR_COLORS ]]; then
      eval `dircolors -b /etc/DIR_COLORS`
    fi
    alias ls="ls --color=auto"
    alias cal="cal -m"
    alias ll="ls -h -l"
    alias la="ls -a"
    alias grep="grep --color=auto"
    alias egrep="egrep --color=auto"
    which bsdtar >/dev/null && alias tar="bsdtar"
    ;;
esac

# }}}

# {{{ General aliases

alias :q="exit"

# }}}

# {{{ "Smart completion" (imperfect copy of zsh's one)

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# }}}

# {{{ Prompts

PS2="\[\033[01;35m\]>\[\033[00m\] "
PS3="\[\033[01;35m\]?#\[\033[00m\] "

# }}}

# {{{ title()

# Display the title, and append the command if given in $1
function title {
  t="${USER}@${HOSTNAME%%.*} ${PWD/$HOME/~}"

  case $TERM in
    screen)
      echo -ne "\ek$t\e\\"
      echo -ne "\e]0;$t\a"
      ;;
    xterm*|rxvt*|Eterm|eterm)
      echo -ne "\e]0;$t\a"
      ;;
  esac
}

# }}}

# {{{ precmd()

function precmd {
  # Save return code now
  rcode=$?

  # Set window title
  title

  # Set used colors
  color_reset="\033[00m"
  color_red="\033[22;31m"
  color_bred="\033[01;31m"
  color_bgreen="\033[01;32m"
  color_yellow="\033[22;33m"
  color_byellow="\033[01;33m"
  color_bblue="\033[01;34m"
  color_cyan="\033[22;36m"
  color_white="\033[22;37m"
  color_bwhite="\033[01;37m"
  color_black="\033[22;30m"
  color_bblack="\033[01;30m"

  # Color for non-text things
  local misc="\[${color_white}\]"

  # Change path color given user rights on it
  if [[ -w "${PWD}" ]]; then # can write
    local path_color="${color_bblue}"
  else # other
    local path_color="${color_bred}"
  fi

  # red prompt for root
  if [[ $UID = 0 ]]; then
    local login_color="${color_bred}"
  else
    local login_color="${color_bwhite}"
  fi

  # host color.
  local host_color="${color_bwhite}"

  # Jailed ?
  if [[ "`uname -s`" = 'FreeBSD' && "`sysctl -n security.jail.jailed 2>/dev/null`" = 1 ]]; then
    local jailed="${misc}(\[${color_yellow}\]jail${misc})"
  else
    local jailed=""
  fi
  # Display return code when not 0
  local return_code=""
  [[ ${rcode} != 0 ]] && return_code="${misc}!\[${color_bred}\]${rcode}${misc}! "
  # Host
  local host="\[${host_color}\]\h"
  # User
  local user="${misc}\[${login_color}\]\u${misc}"
  # Current path
  local cwd="\[${path_color}\]\w"
  # $ for user, # for root
  if [[ $UID = 0 ]]; then
    local sign="\[${login_color}\]#"
  else
    local sign="\[${login_color}\]\$"
  fi

  # Set the prompt
  PS1="${return_code}${user}@${host}${jailed} ${cwd} ${sign}\[${color_reset}\] "
}

PROMPT_COMMAND=precmd

# }}}

# vim:filetype=sh:tabstop=8:shiftwidth=2:fdm=marker:
