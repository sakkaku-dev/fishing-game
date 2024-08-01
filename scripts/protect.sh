#!/bin/sh

# Use when using protected assets
CMD="$1"

if [ "$CMD" == "unpack" ]; then
    cd assets
    unzip -d fishing_icons protected.zip
elif [ "$CMD" == "pack" ]; then
    cd assets/fishing_icons
    zip -e -r ../protected.zip *
else
    echo "Unknown command. Available commands: unpack, pack"
fi
