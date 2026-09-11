#!/bin/bash
b=(1 2 3 4 4 5 6)
echo "Array Ele: ${b[@]}"
echo "Array Ele: ${#b[@]}"
echo "Array Ele: ${b[@]:1:3}"
echo "Array Ele: ${b[@]::2}"