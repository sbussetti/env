#!/bin/bash

# shellcheck source=/Users/sbussetti/.bashrc
. "$HOME/.bashrc"

export GOPATH=$HOME/src/go
export PATH=$HOME/src/go/bin/:$PATH

JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME

[[ -e $(command -v rbenv) ]] && eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[[ -e "/usr/local/opt/nvm/nvm.sh" ]] && . "/usr/local/opt/nvm/nvm.sh"

# echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bash_profile
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
# export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
## pyenv compilation flags
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/readline/include"

export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
eval "$(pyenv init -)"
# [[ ! -z $(command -v pyenv-virtualenv-init) ]] && eval "$(pyenv virtualenv-init -)" && pyenv virtualenvwrapper_lazy

eval "$(direnv hook bash)"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# PROMPT
# SHOW_PY=${SHOW_PY:-true}
export SHOW_PY=false
# SHOW_NVM=${SHOW_NVM:-true}
export SHOW_NVM=false
# SHOW_RB=${SHOW_RB:-true}
export SHOW_RB=false
# SHOW_TF=${SHOW_TF:-true}
export SHOW_TF=false
# SHOW_K8S=${SHOW_K8S:-true}
export SHOW_K8S=false

. "$HOME/.bash/PS1.bash"

[[ -e ~/.localrc ]] && . ~/.localrc

# should always go last or at least after all aliases are defined
. ~/.bash/wrap-aliases.bash

# iterm2 integration -- seems to act weird w/ tmux and i don't use the iterm tmux integration
# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
