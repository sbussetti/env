if [[ $- == *i* ]]; then

    export VIRTUAL_ENV_DISABLE_PROMPT=1

    if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
        export TERM=gnome-256color
    elif infocmp xterm-256color >/dev/null 2>&1; then
        export TERM=xterm-256color
    fi

    tput sgr 0 0

    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    SOLAR_BASE1=$(tput setaf 245)
    SOLAR_YELLOW=$(tput setaf 136)
    SOLAR_ORANGE=$(tput setaf 166)
    SOLAR_RED=$(tput setaf 124)
    SOLAR_MAGENTA=$(tput setaf 125)
    SOLAR_VIOLET=$(tput setaf 61)
    SOLAR_BLUE=$(tput setaf 33)
    SOLAR_CYAN=$(tput setaf 37)
    SOLAR_GREEN=$(tput setaf 64)

    style_user="$SOLAR_ORANGE"
    style_host="$SOLAR_YELLOW"

    if [[ "$SSH_TTY" ]]; then
        # connected via ssh
        style_host="$SOLAR_RED"
    elif [[ "$USER" == "root" ]]; then
        # logged in as root
        style_user="$SOLAR_RED"
    fi

    ## these unfortunately vary based on version
    GIT_CLEAN="nothing to commit, working tree clean"

    function parse_git_dirty() {
        [[ $(git status 2> /dev/null | tail -n1) != $GIT_CLEAN ]] && echo "*"
    }

    function parse_git_branch() {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
    }

    function parse_svn_dirty() {
        [[ $(svn status 2> /dev/null) ]] && echo "*"
    }

    function parse_svn_branch() {
        svn info 2> /dev/null | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$' | sed "s/$/$(parse_svn_dirty)/"
    }

    function parse_hg_dirty() {
        [[ $(hg status 2> /dev/null) ]] && echo "*"
    }

    function parse_hg_branch() {
        hg branch 2> /dev/null | awk '{print $1}' | sed "s/$/$(parse_hg_dirty)/"
    }

    function display_virtualenv_path {
      if [ -n "$VIRTUAL_ENV" ]; then
          echo -ne "($(basename $VIRTUAL_ENV)) "
      fi
    }

    function display_nvm_version {
        if [ -n "$NVM_BIN" ]; then
            echo -ne "($($NVM_BIN/node --version)) "
        fi
    }

    VENV="\[$SOLAR_GREEN\]\$(display_virtualenv_path)";
    NVMV="\[$SOLAR_RED\]\$(display_nvm_version)";


    PS1="${VENV}${NVMV}\[${BOLD}${style_user}\]\u\[$SOLAR_BASE1\]@\[$style_host\]\h\[$SOLAR_BASE1\]: \[$SOLAR_GREEN\]\W\[$SOLAR_BASE1\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_git_branch)\[$SOLAR_BASE1\]\$([[ -n \$(svn info 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_svn_branch)\[$SOLAR_BASE1\]\$([[ -n \$(hg branch 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_hg_branch)\[$SOLAR_BASE1\] \$ \[$RESET\]"
#"

    #LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    # man colors
    man() {
        env \
        LESS_TERMCAP_mb=$(printf "$BOLD") \
        LESS_TERMCAP_md=$(printf "$SOLAR_BLUE") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "$SOLAR_CYAN") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "$SOLAR_GREEN") \
            man "$@"
    }
 

fi

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

# EVERYONE GETS NEW HISTFILES
[ -d ~/.history.d ] || mkdir --mode=0700 ~/.history.d
export HISTFILE="${HOME}/.history.d/history-"`uname -n`"-"`id -nu`"-"`tty|cut -c6-`
export HISTCONTROL=erasedups
export HISTSIZE=10000
set show-all-if-ambiguous on
shopt -s histappend

complete -o bashdefault -o default -o nospace -F _ssh ssh 2>/dev/null || complete -o default -o nospace -F _ssh ssh
complete -o bashdefault -o default -o nospace -F _ssh scp 2>/dev/null || complete -o default -o nospace -F _ssh scp
complete -o bashdefault -o default -o nospace -F _ssh rsync 2>/dev/null || complete -o default -o nospace -F _ssh rsync

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="/Users/sbussetti/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$HOME/.yarn/bin:$PATH"
