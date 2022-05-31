#!/usr/bin/env bash

# shellcheck source=/Users/sbussetti/.bashrc

# echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bash_profile
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
# export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
## pyenv compilation flags
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/readline/include"


. "$HOME/.bashrc"

export GOPATH=$HOME/src/go
export PATH=$HOME/src/go/bin/:$PATH

if [[ -f "/usr/libexec/java_home" ]]; then
  JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0)
  export JAVA_HOME
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
[[ -e $(command -v pyenv) ]] && eval "$(pyenv init --path)"
[[ -e $(command -v pyenv) ]] && eval "$(pyenv init -)"


[[ -e $(command -v rbenv) ]] && eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[[ -e "/usr/local/opt/nvm/nvm.sh" ]] && . "/usr/local/opt/nvm/nvm.sh"

[[ -e $(command -v direnv) ]] && eval "$(direnv hook bash)"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# PS1 OPTIONS
export SHOW_PY=true
# SHOW_NVM
export SHOW_RB=true
# SHOW_TF
export SHOW_K8S=false
# DEBUG_PS1=false
export SHOW_GIT=true
# SHOW_HG
# SHOW_SVN

. "$HOME/.bash/PS1.bash"
# export PS1="\u@\h \W \\$ "

[[ -e ~/.localrc ]] && . ~/.localrc

# should always go last or at least after all aliases are defined
. ~/.bash/wrap-aliases.bash

# iterm2 integration -- seems to act weird w/ tmux and i don't use the iterm tmux integration
# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
