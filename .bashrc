#!/bin/bash
# EVERYONE GETS NEW HISTFILES
[ -d ~/.history.d ] || mkdir -m 0700 ~/.history.d
HISTFILE="${HOME}/.history.d/history-"$(uname -n)"-"$(id -nu)"-"$(tty|cut -c6-)
export HISTFILE
export HISTCONTROL=erasedups:ignoreboth
export HISTSIZE=10000
set show-all-if-ambiguous on
shopt -s histappend

# https://superuser.com/questions/544989/does-tmux-sort-the-path-variable/583502#583502
if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi
export PATH=${HOME}/bin:/usr/local/sbin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# Exports and Aliases
# Make vim the default editor
export EDITOR="vim"
set -o vi
VIM=$(basename $(command -v vim))
LS=$(basename $(command -v ls))
KUBECTL=$(basename $(command -v kubectl))
GIT=$(basename $(command -v git))

alias stop-synergy="launchctl unload /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"
alias start-synergy="launchctl load /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"

alias ll="$LS -al"
alias vi=$VIM
alias v=$VIM
alias g=$GIT
alias k=$KUBECTL
alias kn="$KUBECTL --namespace"
alias ka="$KUBECTL --all-namespaces=true"
alias tf="terraform"
alias sn="send-notification"

# GIT ALIASES
alias g='git'
alias gg='g co -'
alias gm='g merge -'
alias gh='g hist'
alias gdlb='git branch -r | awk '"'"'{print $1}'"'"' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '"'"'{print $1}'"'"' | xargs git branch -d'

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
