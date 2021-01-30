#!/usr/bin/with-contenv bash

set -eE -o functrace

failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}

trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

IRSSI_SCRIPTS="/config/.irssi/scripts/"
IRSSI_HOME="/config/.irssi/"
HOME_DIR="/config/"
RUTORRENT_PLUGINS="/app/rutorrent/plugins/"

# make folders
mkdir -p /config/tmp /detach_sess

# copy config files/set links etc...
[[ ! -L /home/abc/.autodl ]] && ln -s /config/.autodl /home/abc/.autodl
[[ ! -f /config/.autodl/autodl.cfg ]] && cp /config/defaults/autodl.cfg /config/.autodl/autodl.cfg
[[ ! -f "${RUTORRENT_PLUGINS}/autodl-irssi/conf.php" ]] && cp /config/defaults/conf.php "${RUTORRENT_PLUGINS}/autodl-irssi/conf.php"
