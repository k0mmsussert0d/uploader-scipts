#!/usr/bin/with-contenv bash

IRSSI_SCRIPTS="/config/.irssi/scripts/"
IRSSI_HOME="/config/.irssi/"
HOME_DIR="/config/"
RUTORRENT_PLUGINS="/app/rutorrent/plugins/"

# create .autodl config dir and link
[[ ! -d "${HOME_DIR}/.autodl" ]] && (mkdir "${HOME_DIR}/.autodl" && chown -R abc:abc "${HOME_DIR}/.autodl")
[[ ! -d /home/abc ]] && (mkdir /home/abc && chown -R abc:abc /home/abc)

# get rutorrent plugin
[[ ! -d "${RUTORRENT_PLUGINS}/autodl-irssi/.git" ]] && (git clone https://github.com/autodl-community/autodl-rutorrent.git "${RUTORRENT_PLUGINS}/autodl-irssi/" && \
chown -R abc:abc "${RUTORRENT_PLUGINS}/autodl-irssi/")

# get autodl script for irssi
[[ ! -d "${IRSSI_SCRIPTS}/.git" ]] && (mkdir -p "${IRSSI_SCRIPTS}" && \
  git clone https://github.com/autodl-community/autodl-irssi.git ${IRSSI_SCRIPTS} && \
  mkdir "${IRSSI_SCRIPTS}/autorun" && \
  ln -s "${IRSSI_SCRIPTS}/autodl-irssi.pl" "${IRSSI_SCRIPTS}/autorun/autodl-irssi.pl" && \
  chown -R abc:abc "${IRSSI_HOME}" )

# get updated trackers for irssi-autodl
[[ ! -d "${IRSSI_SCRIPTS}/AutodlIrssi/trackers" ]] && (mkdir -p "${IRSSI_SCRIPTS}/AutodlIrssi/trackers" && chown -R abc:abc "${IRSSI_SCRIPTS}/AutodlIrssi/trackers")
wget --quiet -O /tmp/trackers.zip https://github.com/autodl-community/autodl-trackers/archive/master.zip && \
cd "${IRSSI_SCRIPTS}/AutodlIrssi/trackers" && \
unzip -q -o -j /tmp/trackers.zip && \
rm /tmp/trackers.zip

# update rutorrent plugin
cd "${RUTORRENT_PLUGINS}/autodl-irssi/" || exit
git pull
chown -R abc:abc "${RUTORRENT_PLUGINS}/autodl-irssi/"

# make sure perl is in irssi startup
echo "load perl" > "${IRSSI_HOME}/startup"

# symlink autodl/irssi folders to root
ln -s "${HOME_DIR}/.autodl" /root/.autodl
ln -s "${IRSSI_HOME}" /root/.irssi
chown -R abc:abc /root/.autodl
chown -R abc:abc /root/.irssi

# update autodl script for irssi
cd ${IRSSI_SCRIPTS} || exit
git pull
chown -R abc:abc /config/.irssi
