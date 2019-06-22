#!/bin/bash

# by Maksymilian Babarowski (k0mmsussert0d)
# https://github.com/k0mmsussert0d/uploader-scipts/

# This scripts takes one directory as a parameter and transcodes all the .flac
# and .wav files using a commands specified in ${OPTIONS[@]} array. The output 
# files located in the directories created alongside the input directory. For
# more detailed description about how to use this tool, please reffer to the
# README.md file.

set -o errexit
set -o nounset

if [[ ! -z "$1" ]]; then
    if [[ -d "$1" ]]; then
        DIR_NAME="$1"
        readonly FLAC_DIR="$(pwd)/$DIR_NAME"
        DIR_NAME=$(basename "$DIR_NAME")
    else
        echo "$1 is not a proper directory"
        exit 1
    fi
else
    echo "No input directory was provided."
    exit 1
fi

declare -A OPTIONS
OPTIONS['CD - FLAC']=""
OPTIONS['CD - MP3 - 320']='ffmpeg -i "$input" -b:a 320k "$output.mp3"'
OPTIONS['CD - MP3 - V0']='ffmpeg -i "$input" -q:a 0 "$output.mp3"'

for K in "${!OPTIONS[@]}"; do
    V="${OPTIONS[$K]}"
    if [[ -z "$V" ]]; then
        FLAC_DIR_EXT="$K"
        continue
    fi

    NEW_DIR="$FLAC_DIR/../$DIR_NAME ($K)" 
    mkdir "$NEW_DIR"

    for f in "$FLAC_DIR"/*; do
        if [[ -d "$f" ]]; then
            continue
        elif [[ -f "$f" ]]; then
            filename=$(basename "$f")
            case "$f" in
                *.flac | *.wav )
                    input="$f"
                    filename=${filename%.*} # trim .flac or .wav extension
                    output="$NEW_DIR/$filename"
                    eval "$V"
                    ;;
                *.jpg | *.jpeg | *.png | *.bmp )
                    cp "$f" "$NEW_DIR/$filename"
                    ;;
                *.log | *.cue | *.txt )
                    ;;
            esac
        fi
    done
done

mv "$FLAC_DIR" "FLAC_DIR ($FLAC_DIR_EXT)"