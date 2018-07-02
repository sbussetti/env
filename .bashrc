# EVERYONE GETS NEW HISTFILES
[ -d ~/.history.d ] || mkdir -m 0700 ~/.history.d
export HISTFILE="${HOME}/.history.d/history-"`uname -n`"-"`id -nu`"-"`tty|cut -c6-`
export HISTCONTROL=erasedups:ignoreboth
export HISTSIZE=10000
set show-all-if-ambiguous on
shopt -s histappend

complete -o bashdefault -o default -o nospace -F _ssh ssh 2>/dev/null || complete -o default -o nospace -F _ssh ssh
complete -o bashdefault -o default -o nospace -F _ssh scp 2>/dev/null || complete -o default -o nospace -F _ssh scp
complete -o bashdefault -o default -o nospace -F _ssh rsync 2>/dev/null || complete -o default -o nospace -F _ssh rsync

export PATH=${HOME}/bin:/usr/local/sbin:$PATH

# Exports and Aliases
# Make vim the default editor
export EDITOR="vim"
set -o vi
VIM=$(command -v vim)
LS=$(command -v ls)
KUBECTL=$(command -v kubectl)
GIT=$(command -v git)

alias ll="$LS -al"
alias vi=$VIM
alias v=$VIM
alias g=$GIT
alias k=$KUBECTL
alias kn="$KUBECTL --namespace"
alias ka="$KUBECTL --all-namespaces=true"

# GIT ALIASES
alias g='git'
alias gg='g co -'
alias gm='g merge -'
alias gs='g st'
alias gt='g tag'
alias gd='g diff'
alias gh='g hist'


# known_hosts based completion

# __ssh_known_hosts() {
#     if [[ -f ~/.ssh/known_hosts ]]; then
#         cut -d " " -f1 ~/.ssh/known_hosts | cut -d "," -f1
#     fi
# }

# _ssh() {
#     local cur known_hosts
#     COMPREPLY=()
#     cur="${COMP_WORDS[COMP_CWORD]}"
#     known_hosts="$(__ssh_known_hosts)"
    
#     if [[ ! ${cur} == -* ]] ; then
#         COMPREPLY=( $(compgen -W "${known_hosts}" -- ${cur}) )
#         return 0
#     fi
# }

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"
