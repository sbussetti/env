#!/bin/bash 

export LAST_FG=

if [[ $- == *i* ]]; then

    export VIRTUAL_ENV_DISABLE_PROMPT=1

    if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
        export TERM=gnome-256color
    elif infocmp screen-256color >/dev/null 2>&1; then
        export TERM=screen-256color
    elif infocmp xterm-256color >/dev/null 2>&1; then
        export TERM=xterm-256color
    elif infocmp term-256color >/dev/null 2>&1; then
        export TERM=term-256color
    fi

    tput sgr 0 0

    SEP=""
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    WHITE=$(tput setaf 7)
    SOLAR_BASE1=$(tput setaf 245)
    SOLAR_BASE1_BG=$(tput setab 245)
    SOLAR_BASE2=$(tput setaf 246)
    SOLAR_BASE2_BG=$(tput setab 246)
    SOLAR_BASE3=$(tput setaf 247)
    SOLAR_BASE3_BG=$(tput setab 247)
    SOLAR_BASE4=$(tput setaf 248)
    SOLAR_BASE4_BG=$(tput setab 248)
    SOLAR_YELLOW=$(tput setaf 136)
    SOLAR_ORANGE=$(tput setaf 166)
    SOLAR_RED=$(tput setaf 124)
    SOLAR_RED_BG=$(tput setab 124)
    SOLAR_MAGENTA=$(tput setaf 125)
    SOLAR_MAGENTA_BG=$(tput setab 125)
    SOLAR_VIOLET=$(tput setaf 61)
    SOLAR_BLUE=$(tput setaf 33)
    SOLAR_BLUE_BG=$(tput setab 33)
    SOLAR_CYAN=$(tput setaf 37)
    # SOLAR_CYAN_BG=$(tput setab 37)
    SOLAR_GREEN=$(tput setaf 64)
    SOLAR_GREEN_BG=$(tput setab 64)


    style_user="$SOLAR_YELLOW"
    style_host="$SOLAR_ORANGE"

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
        [[ $(git status 2> /dev/null | tail -n1) != "$GIT_CLEAN" ]] && echo "*"
    }

    function parse_git_branch() {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
    }

    function parse_svn_dirty() {
        [[ $(svn status 2> /dev/null) ]] && echo "*"
    }

    function parse_svn_branch() {
        svn info 2> /dev/null | grep '^URL:' | grep -E -o '(tags|branches)/[^/]+|trunk' | grep -E -o '[^/]+$' | sed "s/$/$(parse_svn_dirty)/"
    }

    function parse_hg_dirty() {
        [[ $(hg status 2> /dev/null) ]] && echo "*"
    }

    function parse_hg_branch() {
        hg branch 2> /dev/null | awk '{print $1}' | sed "s/$/$(parse_hg_dirty)/"
    }

    function display_python_env {
      PYENV_VER=$(pyenv version-name)

      if [ -n "$PYENV_VER" ] || [ -n "$VIRTUAL_ENV" ]; then
        echo -n "${SOLAR_GREEN}🐍";
        if [ -n "$PYENV_VER" ]; then
            echo -ne "${PYENV_VER}"
        else
            echo -ne "system"
        fi
        if [ -n "$VIRTUAL_ENV" ]; then
            echo -ne ":$(basename "$VIRTUAL_ENV")"
        fi
        echo -ne " $RESET";
      fi
    }

    function display_nvm_version {
      if [ -n "$NVM_BIN" ]; then
        echo -ne "${SOLAR_RED}⬢ $("$NVM_BIN"/node --version | sed -E 's/^v//') $RESET"
      fi
    }

    function display_rbenv_version {
        RBENV_VERSION=$(rbenv version | sed -E 's/[ -].*\(.*$//')
        if [ -n "$RBENV_VERSION" ]; then
          echo -ne "${SOLAR_MAGENTA}玉$RBENV_VERSION $RESET"
        fi
    }

    function display_current_k8s_context {
      K8S_CTX=$(kubectl config current-context 2>&1 | sed 's/error: current-context is not set/*/')
      if [ -n "$K8S_CTX" ] && [ "$K8S_CTX" != "*" ]; then
        K8S_AUTHINFO=$(kubectl config get-contexts "$K8S_CTX" --no-headers=true | awk '{print $4}' )
        echo -ne "$SOLAR_BLUE"
        if [ -n "$K8S_AUTHINFO" ]; then
          # K8S_AUTHINFO_SHORT="$(echo "$K8S_AUTHINFO" | cut -d':' -f1 | cut -c 1-15):$(echo "$K8S_AUTHINFO" | cut -d':' -f2 | cut -c 1-10)"
          K8S_AUTHINFO=$(echo "$K8S_AUTHINFO" | sed 's/@.*//')
          echo -ne "⎈ ${K8S_AUTHINFO}"
        else
          echo -ne "⎈ ${K8S_CTX}"
        fi
        echo -ne " $RESET"
        LAST_FG=$SOLAR_BLUE
      fi
    }

    # user part

    PS1="\$(display_python_env)\$(display_nvm_version)\$(display_rbenv_version)\$(display_current_k8s_context)\[$SOLAR_BASE1\]\n\[$style_user\]\u\[$SOLAR_BASE1\]@\[$style_host\]\h\[$SOLAR_BASE1\] \[$SOLAR_GREEN\]\W\[$SOLAR_BASE1\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_git_branch)\[$SOLAR_BASE1\]\$([[ -n \$(svn info 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_svn_branch)\[$SOLAR_BASE1\]\$([[ -n \$(hg branch 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_hg_branch)\[$SOLAR_BASE1\] \[$SOLAR_VIOLET\]\$\[$SOLAR_BASE1\] \[$RESET\]"
#"

    #LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    # man colors
    man() {
        env \
        LESS_TERMCAP_mb="$(printf "%s" "$BOLD")"  \
        LESS_TERMCAP_md="$(printf "%s" "$SOLAR_BLUE")" \
        LESS_TERMCAP_me="$(printf "\e[0m")" \
        LESS_TERMCAP_se="$(printf "\e[0m")" \
        LESS_TERMCAP_so="$(printf "%s" "$SOLAR_CYAN")" \
        LESS_TERMCAP_ue="$(printf "\e[0m")" \
        LESS_TERMCAP_us="$(printf "%s" "$SOLAR_GREEN")" \
            man "$@"
    }

fi
