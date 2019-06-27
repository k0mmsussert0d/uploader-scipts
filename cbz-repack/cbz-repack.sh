#!/bin/bash

# by Maksymilian Babarowski (k0mmsussert0d)
# https://github.com/k0mmsussert0d/uploader-scipts/

# This script repacks a zip archive into cbz archive and
# uploads 10 sample pages to uguu.se 

set -o errexit

function cleanup() {
    rm -rf "$TEMP_DIR"
}

if [[ -z $1 ]]; then
    echo "No arguments provided!"
    exit 1
elif [[ $1 == "-rm" ]]; then
    readonly OPT_RM=1
    if [[ -z $2 ]]; then
        echo "No file provided!"
        exit 1
    elif [[ ! -f $2 ]]; then
        echo "No valid file provided!"
        exit 1
    else
        readonly SRC_FILE=$(readlink -f "$2")
    fi
else
    if [[ ! -f $1 ]]; then
        echo "No valid file provided!"
        exit 1
    fi
    
    readonly SRC_FILE=$(readlink -f "$1")
    readonly OPT_RM=0
fi

set -o nounset

readonly SRC_FILE_DIR=$(dirname "$SRC_FILE")
readonly SRC_FILE_NAME=$(basename "$SRC_FILE")

readonly DST_FILE="${SRC_FILE%.*}.cbz"
readonly DST_FILE_NAME=$(basename "$DST_FILE")

readonly TEMP_DIR="$SRC_FILE_DIR/tempdir"
readonly UPLOADS_FILE="$SRC_FILE_DIR/uplinks"

trap 'cleanup; exit 1' INT TERM EXIT

mkdir "$TEMP_DIR"
unzip "$SRC_FILE" -d "$TEMP_DIR" || { echo "Provided file is not a valid ZIP archive"; cleanup; exit 1; }
( cd "$TEMP_DIR" ; zip -0 "$DST_FILE" * )

> "$UPLOADS_FILE" # clear content
find "$TEMP_DIR" *.* | sort -R | tail -10 | while read file; do
    ext="${file##*.}"
    ( cat "$file" | curl -F file=@- -F name="sample.$ext" https://uguu.se/api.php?d=upload-tool >> "$UPLOADS_FILE" ) || { echo "Failed to upload the file"; cleanup; exit 1; }
    echo "" >> "$UPLOADS_FILE" # \n
done

if [[ $OPT_RM -eq 1 ]]; then
    rm "$SRC_FILE"
fi

cleanup
exit 0