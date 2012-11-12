#
# .bashrc - interactive shell configuration
#

# check for interactive
[[ $- = *i* ]] || return

export TTY=$(tty)
export GPG_TTY=$TTY

# shell opts: see bash(1)
shopt -s cdspell dirspell extglob histverify no_empty_cmd_completion checkwinsize

set -o notify           # notify of completed background jobs immediately
ulimit -S -c 0 -n 4096  # disable core dumps
stty -ctlecho           # turn off control character echoing

if [[ $TERM = linux ]]; then
  setterm -regtabs 2    # set tab width of 4 (only works on TTY)
fi

# more for less
export LESS=-R # use -X to avoid sending terminal initialization
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd *"
export HISTCONTROL="ignoreboth:erasedups"
export HISTSIZE=1000
export HISTFILESIZE=2000

source_bash_completion() {
  local f
  [[ $BASH_COMPLETION ]] && return 0
  for f in /{etc,usr/share/bash-completion}/bash_completion; do
    if [[ -r $f ]]; then
      . "$f"
      return 0;
    fi
  done
}

# External config
if [[ -r ~/.dircolors ]] && type -p dircolors >/dev/null; then
  eval $(dircolors -b "$HOME/.dircolors")
fi

source_bash_completion
unset -f source_bash_completion

# git prompt
[[ -f /usr/share/git/git-prompt.sh ]] && . /usr/share/git/git-prompt.sh

for config in .aliases .functions .prompt .bashrc."$HOSTNAME"; do
  [[ -r ~/$config ]] && . ~/"$config"
done
unset config

if type -p poptart >/dev/null && (( UID != 0 )); then
  keys=("$HOME"/.ssh/id_rsa!(*.pub))
  eval $(poptart -p)
  unset keys
fi
