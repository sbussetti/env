#!/bin/bash 

if [[ $- == *i* ]]; then

    export VIRTUAL_ENV_DISABLE_PROMPT=1

    if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
        export TERM=gnome-256color
    elif infocmp xterm-256color >/dev/null 2>&1; then
        export TERM=xterm-256color
    elif infocmp term-256color >/dev/null 2>&1; then
        export TERM=term-256color
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

    function display_python_env {
      PYENV_VER=$(pyenv version-name)
      if [ -s $PYENV_VER ] || [ -s $VIRTUAL_ENV ]; then
        echo -ne "⟬";
        if [ -n "$PYENV_VER" ]; then
            echo -ne "${PYENV_VER}"
        else
            echo -ne "sys"
        fi
        if [ -n "$VIRTUAL_ENV" ]; then
            echo -ne ":$(basename $VIRTUAL_ENV)"
        fi
        echo -ne "⟭";
      fi
    }
    VENV="\[$SOLAR_GREEN\]\$(display_python_env)";

    function display_nvm_version {
        if [ -n "$NVM_BIN" ]; then
            echo -ne "⟬$($NVM_BIN/node --version | sed -E 's/^v//')⟭"
        fi
    }
    NVMV="\[$SOLAR_RED\]\$(display_nvm_version)";

    function display_rbenv_version {
        RBENV_VERSION=$(rbenv version | sed -E 's/[ -].*\(.*$//')
        if [ -n "$RBENV_VERSION" ]; then
            echo -ne "⟬${RBENV_VERSION}⟭"
        fi
    }
    RBENV="\[$SOLAR_MAGENTA\]\$(display_rbenv_version)";

    function display_current_k8s_context {
      K8S_CTX=$(kubectl config current-context 2>&1 | sed 's/error: current-context is not set/*/')
      # K8S_AUTHINFO=$(kubectl config get-contexts $K8S_CTX --no-headers=true | awk '{print $4}' )
      #   if [ -n "$K8S_AUTHINFO" ]; then
      #     K8S_AUTHINFO_SHORT="$(echo $K8S_AUTHINFO | cut -d':' -f1 | cut -c 1-15):$(echo $K8S_AUTHINFO | cut -d':' -f2 | cut -c 1-10)"
      #       echo -ne "〖${K8S_AUTHINFO_SHORT}〗"
      #   fi
      if [ -n "$K8S_CTX" ]; then
        echo -ne "〖${K8S_CTX}〗"
      fi
    }
    K8S_CTX="\[$SOLAR_BLUE\]\$(display_current_k8s_context)";


    # user part
    # \[${BOLD}${style_user}\]\u\[$SOLAR_BASE1\]

    PS1="${VENV}${NVMV}${RBENV}${K8S_CTX}\[$SOLAR_BASE1\]\n\[$SOLAR_YELLOW\]\u\[$SOLAR_BASE1\]@\[$SOLAR_ORANGE\]\h\[$SOLAR_BASE1\] \[$SOLAR_GREEN\]\W\[$SOLAR_BASE1\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_git_branch)\[$SOLAR_BASE1\]\$([[ -n \$(svn info 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_svn_branch)\[$SOLAR_BASE1\]\$([[ -n \$(hg branch 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_hg_branch)\[$SOLAR_BASE1\] \[$SOLAR_VIOLET\]\$\[$SOLAR_BASE1\] \[$RESET\]"
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
