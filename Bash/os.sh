#!/bin/bash

os=$(uname)

if [[ "$os" == "Linux" ]]; then
    echo "operating system: Linux"
elif [[ "$os" == "Darwin" ]]; then
    echo "operating system: macOS"
elif [[ "$os" == CYGWIN* || "$os" == MINGW* ]]; then
    echo "operating system: Windows (Git Bash أو MinGW)"
else
    echo "operating system Felid: $os"
fi
