#!/bin/bash

MODE=$1

if [[ "$MODE" == "-s" ]]; then
multitail \
    -kS '^.* \[(.*)\]( "[^"]*")( [^ ]*) .*( .*)$' -l "ssh app01.filmbot.com tail -f /var/log/nginx/filmbot-access.log" \
    -kS '^.* \[(.*)\]( "[^"]*")( [^ ]*) .*( .*)$' -l "ssh app02.filmbot.com tail -f /var/log/nginx/filmbot-access.log"
else
multitail \
    -l "ssh app01.filmbot.com tail -f /var/log/nginx/filmbot-access.log" \
    -l "ssh app02.filmbot.com tail -f /var/log/nginx/filmbot-access.log"
fi
