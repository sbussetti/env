#!/bin/bash

# shellcheck disable=SC2123,SC2046,SC2139,SC2142,SC2086

# EVERYONE GETS NEW HISTFILES
[ -d ~/.history.d ] || mkdir -m 0700 ~/.history.d
HISTFILE="${HOME}/.history.d/history-$(uname -n)-$(id -nu)-$(tty|cut -c6-)"
export HISTFILE
export HISTCONTROL=erasedups:ignoreboth
export HISTSIZE=10000
export HISTTIMEFORMAT="%F %T: "
set show-all-if-ambiguous on
shopt -s histappend

# color
export CLICOLOR=true
# LSCOLOR=""

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
GIT=$(basename $(command -v git))

if [[ -e $(command -v kubectl) ]]; then
    KUBECTL=$(basename $(command -v kubectl))
    alias k=$KUBECTL
    alias ka="$KUBECTL --all-namespaces=true"
    alias kn="$KUBECTL --namespace"
    alias kd="$KUBECTL describe"
    alias kcuc="$KUBECTL config use-context"
    alias ksn="$KUBECTL config set-context --current --namespace"
    alias kunset="$KUBECTL config unset current-context"
    kusn() {
      $KUBECTL config unset contexts.$($KUBECTL config current-context).namespace ;
    }
fi

alias stop-synergy="launchctl unload /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"
alias start-synergy="launchctl load /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"

alias ll="$LS -al"
alias vi=$VIM
alias v=$VIM
alias g=$GIT
alias tf="terraform"
alias sn="send-notification"
alias chomp="perl -pi -e 'chomp if eof'"
alias kill-vpn="pgrep -i '(cisco|vpnagent)' | sudo xargs kill -9"
1>/dev/null 2>&1 which colordiff && alias diff="colordiff"

alias drit="docker run -it"

# GIT ALIASES
alias g='git'
alias gg='g co -'
alias gh='g hist'
alias gdlb='git branch -r | awk '"'"'{print $1}'"'"' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '"'"'{print $1}'"'"' | xargs git branch -d'
alias gdmrb='git branch -r --merged | grep -v master | sed '"'"'s/origin\///'"'"' | xargs -n 1 git push --delete origin'


export PATH=/Users/sbussetti/obin:$PATH

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

[[ -e "${HOME}/lib/oracle-cli/lib/python3.7/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "${HOME}/lib/oracle-cli/lib/python3.7/site-packages/oci_cli/bin/oci_autocomplete.sh"

. ~/.bash/urlencode.bash

function gnb() {
    gnb_REMOTE=$1;
    gnb_BRANCH=$2;
    if [[ "x$2" == "x" ]]; then gnb_REMOTE=origin; gnb_BRANCH=$1; fi
    g co -b "$gnb_BRANCH" && g pu -u "$gnb_REMOTE" "$gnb_BRANCH"
}

function gdt() {
    gdt_LOCAL='';
    gdt_REMOTE='';
    for tag in "$@"; do
        gdt_LOCAL="$gdt_LOCAL $tag";
        gdt_REMOTE="$gdt_REMOTE :${tag}";
    done

    if [[ "x$gdt_LOCAL" != "x" ]]; then
        g pu origin "$gdt_REMOTE" && git tag --delete "$gdt_LOCAL"
    fi
}

function gdb() {
    gdb_LOCAL='';
    gdb_REMOTE='';
    for branch in "$@"; do
        gdb_LOCAL="$gdb_LOCAL $branch";
        gdb_REMOTE="$gdb_REMOTE :${branch}";
    done

    if [[ "x$gdb_LOCAL" != "x" ]]; then
        g pu origin "$gdb_REMOTE" && git branch -D "$gdb_LOCAL"
    fi
}
