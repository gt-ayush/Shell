#!/bin/bash
echo "Arg 1: $1"
echo "Arg 2: $2"
echo "Arg 10: ${10}"

if [ $# -lt 2 ]; then
    echo "Please provide at least 2 arguments."
else
    echo "You provided $# arguments."
fi

for arg in "$@"; do
    echo "Argument: $arg"
done