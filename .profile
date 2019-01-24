#!/bin/bash

# shellcheck source=/Users/sbussetti/.bashrc
. "$HOME/.bashrc"


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

function dcbash() {
    docker-compose exec "$1" /bin/bash
}

_insed(){
    CHANGED=0
    for FILE in $(ack -l "$1" "$PWD"); do
        if sed -i '' "s/${1}/${2}/${3}g" "$FILE"; then
            ((CHANGED++));
        fi;
    done;
    echo "$CHANGED files changed";
}
alias insed=_insed


export GOPATH=$HOME/src/go

JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME

[[ -e $(command -v rbenv) ]] && eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[[ -e "/usr/local/opt/nvm/nvm.sh" ]] && . "/usr/local/opt/nvm/nvm.sh"

eval "$(pyenv init -)"
[[ ! -z $(command -v pyenv-virtualenv-init) ]] && eval "$(pyenv virtualenv-init -)" && pyenv virtualenvwrapper

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion


. "$HOME/.bash/PS1.bash"
[[ -e ~/.localrc ]] && . ~/.localrc

# should always go last or at least after all aliases are defined
. ~/.bash/wrap-aliases.bash
