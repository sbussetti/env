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

    function parse_git_dirty() {
        [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
    }

    function parse_git_branch() {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
    }

    function parse_svn_dirty() {
        [[ $(svn status 2> /dev/null) ]] && echo "*"
    }

    function parse_svn_branch {
        svn info 2> /dev/null | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$' | sed "s/$/$(parse_svn_dirty)/"
    }

    function display_virtualenv_path {
      if [ -n "$VIRTUAL_ENV" ]; then
        ref=$(basename $VIRTUAL_ENV)
        echo -ne "${ref}"
      fi
    }

    PS1="\[${BOLD}${style_user}\]\u\[$SOLAR_BASE1\]@\[$style_host\]\h\[$SOLAR_BASE1\]: \[$SOLAR_GREEN\]\W\[$SOLAR_BASE1\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_git_branch)\[$SOLAR_BASE1\]\$([[ -n \$(svn info 2> /dev/null) ]] && echo \" on \")\[$SOLAR_CYAN\]\$(parse_svn_branch)\[$SOLAR_BASE1\] \$ \[$RESET\]"

fi

# Exports

# Make vim the default editor
export EDITOR="vim"
set -o vi
