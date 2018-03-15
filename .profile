. $HOME/.bashrc
. $HOME/.bash/PS1.bash

# known_hosts based completion

__ssh_known_hosts() {
    if [[ -f ~/.ssh/known_hosts ]]; then
        cut -d " " -f1 ~/.ssh/known_hosts | cut -d "," -f1
    fi
}

_ssh() {
    local cur known_hosts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    known_hosts="$(__ssh_known_hosts)"
    
    if [[ ! ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${known_hosts}" -- ${cur}) )
        return 0
    fi
}

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    . /usr/local/share/bash-completion/bash_completion
fi

# Exports and Aliases
# Make vim the default editor
export EDITOR="vim"
set -o vi
VIM=$(command -v vim)
LS=$(command -v ls)

alias ll="$LS -al"
alias vi=$VIM
alias v=$VIM
alias g='git'

# GIT ALIASES
# alias fullpull='git co master && git pull && git co develop && git pull;'
# alias gitlog='git log --pretty=oneline --abbrev-commit'
# alias gco='git co'
alias g='git'
alias gr='git remote'
alias grv='gr -v'
alias gg='gco -'
alias gmffo='git merge --ff-only -'
alias gm='git merge -'
alias gmm='gm -m merge'
alias gt='git tag'
alias gpu='git push'
alias gput='gpu && git push --tags'
alias gpl='git pull'
alias gs='git stat'
alias gd='git diff'
alias gf='git fetch'
alias ga='git add .'
# alias gc='git commit'
# alias gca='gc -a'
# alias gcam='gca -m'
alias gspl='git submodule foreach git pull origin master'
alias gh='git hist'
alias gb='git branch'
alias gbr='gb -r'
alias gbra='gbr -a'
alias gbd='gb -D'
alias gsh='git add . && git stash'
alias gshl='git stash list'
alias gshp='git stash pop'
alias gshbp='git stash branch stash/pop 0'
function gnb() {
    gnb_REMOTE=$1;
    gnb_BRANCH=$2;
    if [[ "x$2" == "x" ]]; then gnb_REMOTE=origin; gnb_BRANCH=$1; fi
    gco -b $gnb_BRANCH && gpu -u $gnb_REMOTE $gnb_BRANCH
}
function gdt() {
    gdt_LOCAL='';
    gdt_REMOTE='';
    for tag in "$@"; do
        gdt_LOCAL="$gdt_LOCAL $tag";    
        gdt_REMOTE="$gdt_REMOTE :${tag}";    
    done

    if [[ "x$gdt_LOCAL" != "x" ]]; then
        git push origin $gdt_REMOTE && git tag --delete $gdt_LOCAL
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
        git push origin $gdb_REMOTE && git branch -D $gdb_LOCAL
    fi
}
function dcbash() {
    docker-compose exec $1 /bin/bash
}

_insed(){
    CHANGED=0
    for FILE in $(ack -l $1 $PWD); do
        sed -i '' "s/${1}/${2}/${3}g" $FILE;
        if [ $? == 0 ]; then
            ((CHANGED++));
        fi;
    done;
    echo "$CHANGED files changed";
}
alias insed=_insed

export PATH=${HOME}/bin:/usr/local/sbin:$PATH

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

eval "$(rbenv init -)"

if [[ "x$NVM_DIR" == "x" ]]; then
    export NVM_DIR="$HOME/.nvm"
    . "/usr/local/opt/nvm/nvm.sh"
fi

eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
# pyenv virtualenvwrapper

# should always go last or at least after all aliases are defined
. ~/.bash/wrap-aliases.bash
