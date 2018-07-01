#!/bin/bash

echo "Starting...";

{ pulseaudio --daemonize=no --start; } &

trap "pulseaudio --kill; echo Stopped...; exit;" SIGTERM SIGKILL

wait
