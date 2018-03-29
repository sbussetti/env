. $HOME/.bashrc
. $HOME/.bash/PS1.bash


function gnb() {
    gnb_REMOTE=$1;
    gnb_BRANCH=$2;
    if [[ "x$2" == "x" ]]; then gnb_REMOTE=origin; gnb_BRANCH=$1; fi
    g co -b $gnb_BRANCH && g pu -u $gnb_REMOTE $gnb_BRANCH
}
function gdt() {
    gdt_LOCAL='';
    gdt_REMOTE='';
    for tag in "$@"; do
        gdt_LOCAL="$gdt_LOCAL $tag";    
        gdt_REMOTE="$gdt_REMOTE :${tag}";    
    done

    if [[ "x$gdt_LOCAL" != "x" ]]; then
        g pu origin $gdt_REMOTE && git tag --delete $gdt_LOCAL
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
        g pu origin $gdb_REMOTE && git branch -D $gdb_LOCAL
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


export HOMEBREW_GITHUB_API_TOKEN="545dde6fb43a16e53ca13251fee2bbe3caa9b696"

export PGPASSWORD=yaim0Ao3IZeez3a 

. ~/.dynacle

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

eval "$(rbenv init -)"

if [[ "x$NVM_DIR" == "x" ]]; then
    export NVM_DIR="$HOME/.nvm"
    . "/usr/local/opt/nvm/nvm.sh"
fi

eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
# pyenv virtualenvwrapper

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
