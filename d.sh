#!/bin/bash
b="Bat"
a() {
    local b="I am local"
    echo $b
}
a
echo "Value $b"