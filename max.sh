#!/bin/bash

arr=(1 2 3 56 67 8 4 90)
max=${arr[0]}
for i in "${arr[@]}"; do
    if [[ $i -gt $max ]]; then
    max=$i 
    fi
done

echo "Max: $max"