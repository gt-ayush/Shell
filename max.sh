#!/bin/bash

arr=(1 0 2 3 56 67 8 4 90)
low=${arr[0]}
se=$low
for i in "${arr[@]}"; do
    if [[ $i -gt $low ]]; then
    se=$low
    low=$i     
    fi
done

echo "Max: $se"