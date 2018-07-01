#!/bin/bash

PROJ=$HOME/src/popcorn-devops
ANSI=$PROJ/ansible
ENV=${2-development}

. /usr/local/bin/virtualenvwrapper.sh
workon devops
$PROJ/bin/sshagent.sh $HOME/.ssh/popcorn-sys.pem ansible-playbook -i $ANSI/inventory/$1 -l $ENV $ANSI/filmbot.yml
