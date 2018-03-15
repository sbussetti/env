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

