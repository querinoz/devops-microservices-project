#!/bin/bash

nome="João"

if [ -n $nome ]; then
    echo "Hello, World!, $nome"
else
    echo "Hello, World!, (sem nome)"
fi