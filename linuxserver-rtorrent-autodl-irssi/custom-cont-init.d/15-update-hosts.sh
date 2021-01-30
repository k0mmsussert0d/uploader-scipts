#!/usr/bin/with-contenv bash

set -eE -o functrace

failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}

trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

HOSTS="../hosts2"

user_hosts_file="../hosts"

while IFS= read -r line
do
    if ! grep -q "$line" "$HOSTS"; then
        echo "$line" >> $"$HOSTS"
    fi
done < "$user_hosts_file"
