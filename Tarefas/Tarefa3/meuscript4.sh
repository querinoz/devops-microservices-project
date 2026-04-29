#!/bin/bash

nome="João"

contador=1

while [ $contador -le 3 ]; do
    echo "Hello, World!, $nome"

    ((contador++))
done