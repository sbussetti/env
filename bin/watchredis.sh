#!/bin/sh

watch -t 'redis-cli info | tail -n +49' -s5
