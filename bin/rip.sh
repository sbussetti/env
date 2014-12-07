#!/bin/bash

OFFSET=${1-$RIP_OFFSET}
OUTPUT=${2-$RIP_OUTPUT}
if [ -z $OFFSET ]; then OFFSET=0; fi
if [ -z $OUTPUT ]; then OUTPUT=.; fi

CMD="rip cd rip --offset $OFFSET --logger whatcd --output-directory=$OUTPUT --unknown"

echo $CMD
$CMD

