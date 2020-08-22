# vi: ft=bash
# shellcheck disable=SC2034

if [[ ! -z "$DEBUGPS1" ]]; then
  echo PS1 DEBUG ON: $DEBUGPS1
  set -x
fi

SHOW_PY=${SHOW_PY:-false}
SHOW_NVM=${SHOW_NVM:-false}
SHOW_RB=${SHOW_RB:-false}
SHOW_TF=${SHOW_TF:-false}
SHOW_K8S=${SHOW_K8S:-false}
SHOW_SVN=${SHOW_SVN:-false}
SHOW_HG=${SHOW_HG:-false}
SHOW_GIT=${SHOW_GIT:-false}


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

    ########################
    #
    #    SOURCE CONTROL    
    #
    ########################

    ## these strings unfortunately vary based on version of git
    GIT_CLEAN="nothing to commit, working tree clean"

    function parse_git_dirty() {
      [[ $(git status 2> /dev/null | tail -n1) != "$GIT_CLEAN" ]] && echo "*"
    }

    function parse_git_branch() {
      git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
    }

    function display_git_info() {
      if [ "$SHOW_GIT" != true ] || ! (git branch --no-color 1>/dev/null 2>/dev/null); then return; fi
      echo -n " on ${SOLAR_CYAN}$(parse_git_branch)${SOLAR_BASE1}"
    }

    function parse_svn_dirty() {
      [[ $(svn status 2> /dev/null) ]] && echo "*"
    }

    function parse_svn_branch() {
      svn info 2>/dev/null | grep '^URL:' | grep -E -o '(tags|branches)/[^/]+|trunk' | grep -E -o '[^/]+$' | sed "s/$/$(parse_svn_dirty)/"
    }

    function display_svn_info() {
      if [ "$SHOW_SVN" != true ] || ! svn info 2>&1 1>/dev/null; then return; fi
      echo -n " on ${SOLAR_CYAN}$(parse_svn_branch)${SOLAR_BASE1}"
    }

    function parse_hg_dirty() {
      [[ $(hg status 2> /dev/null) ]] && echo "*"
    }

    function parse_hg_branch() {
      hg branch 2> /dev/null | awk '{print $1}' | sed "s/$/$(parse_hg_dirty)/"
    }

    function display_hg_info() {
      if [ "$SHOW_HG" != true ] || ! hg branch 2>&1 1>/dev/null; then return; fi
      echo -n " on ${SOLAR_CYAN}$(parse_hg_branch)${SOLAR_BASE1}"
    }

    # ==================================================== #
    #                                                      #
    #   Current environment for language versions display  #
    #                                                      #
    # ==================================================== #

    function display_python_env {
      if [ "$SHOW_PY" != true ]; then return; fi
      PYENV_VER_FULL=$(pyenv version-name)
      VENV_NAME="$VIRTUAL_ENV"
      # >&2 echo "PEV: $PYENV_VER_FULL"
      if [[ $PYENV_VER_FULL == *"/envs/"* ]]; then
        read -r PYENV_VER VENV_NAME <<<$(echo $PYENV_VER_FULL | awk -F '/' '{print $1" "$3}')
      else
        PYENV_VER=$(echo $PYENV_VER_FULL | awk -F '/' '{print $1}')
      fi

      if [ -n "$PYENV_VER" ] || [ -n "$VENV_NAME" ]; then
        echo -n "${SOLAR_GREEN}🐍";
        if [ -n "$PYENV_VER" ]; then
            echo -ne "${PYENV_VER}"
        else
            echo -ne "system"
        fi
        if [ -n "$VENV_NAME" ]; then
            echo -ne ":$(basename "$VENV_NAME")"
        fi
        echo -ne " $RESET";
      fi
    }

    function display_nvm_version {
      if [ "$SHOW_NVM" != true ]; then return; fi

      if [ -n "$NVM_BIN" ]; then
        echo -ne "${SOLAR_RED}⬢$("$NVM_BIN"/node --version | sed -E 's/^v//') $RESET"
      fi
    }

    function display_rbenv_version {

      if [ "$SHOW_RB" != true ]; then return; fi

      RBENV_VERSION=$(rbenv version | sed -E 's/[ -].*\(.*$//')
      if [ -n "$RBENV_VERSION" ]; then
        echo -ne "${SOLAR_MAGENTA}玉$RBENV_VERSION $RESET"
      fi
    }

    function display_tf_version {
      if [ "$SHOW_TF" != true ]; then return; fi

      TF_VERSION=$(terraform --version | head -1 | sed -E 's/(^Terraform v|\-.*$)//g')
      if [ -n "$TF_VERSION" ]; then
        echo -ne "${SOLAR_VIOLET}ᛅᚫ$TF_VERSION $RESET"
      fi
    }

    function display_current_k8s_context {
      if [ "$SHOW_K8S" != true ]; then return; fi
      K8S_CTX=$(kubectl config current-context 2>&1 | sed -E 's/.*error: current-context is not set.*//')
      if [ -n "$K8S_CTX" ]; then
        echo -ne "${SOLAR_BLUE}⎈"

        K8S_CONTEXT_INFO="$(kubectl config get-contexts "$K8S_CTX" --no-headers=true)"
        if [ -n "$K8S_CONTEXT_INFO" ]; then
          # K8S_AUTHINFO_SHORT="$(echo "$K8S_CONTEXT_INFO" | cut -d':' -f1 | cut -c 1-15):$(echo "$K8S_CONTEXT_INFO" | cut -d':' -f2 | cut -c 1-10)"
          read -r K8S_NAME K8S_CLUSTER K8S_AUTHINFO K8S_NAMESPACE <<<$(awk '{print $2" "$3" "$4" "$5}' <(echo "$K8S_CONTEXT_INFO"))

          if [[ $K8S_AUTHINFO == *"@"* ]]; then # most likely old EKE
            echo -ne " ${K8S_AUTHINFO/@*}"
          else
            echo -ne " ${K8S_CTX}"
            # echo -ne " ${K8S_AUTHINFO}@${K8S_CLUSTER}"
          fi

          if [ -n "$K8S_NAMESPACE" ]; then
            echo -ne "::${K8S_NAMESPACE}"
          fi

        else
          echo -ne " ${K8S_CTX}"
        fi

        if [ "$KUSE_SHELL" == "on" ]; then
          echo -ne "*"
        fi

        echo -ne " $RESET"
      fi
    }

    # ==================================================== #

    function width() {
      stty size | awk '{print $2}'
    }
    function part_sep() {
      if [ "$SHOW_PY" = true ] || [ "$SHOW_NVM" = true ] || [ "$SHOW_RB" = true ] || [ "$SHOW_TF" = true ] || [ "$SHOW_K8S" = true ]; then
        printf "\n​"  # load bearing zero-width space to trip next line
      fi
    }
    # user part
    PS_PART1="\$(display_python_env)\$(display_nvm_version)\$(display_rbenv_version)\$(display_tf_version)\$(display_current_k8s_context)\[$SOLAR_BASE1\]"
    PS_PART2="\[$style_user\]\u\[$SOLAR_BASE1\]@\[$style_host\]\h\[$SOLAR_BASE1\] \[$SOLAR_GREEN\]\W\[$SOLAR_BASE1\]\$(display_git_info)\$(display_svn_info)\$(display_hg_info) \[$SOLAR_VIOLET\]\$\[$SOLAR_BASE1\] \[$RESET\]"
    PS1="$PS_PART1\$(part_sep)$PS_PART2"
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
