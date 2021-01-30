#!/bin/bash

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

# exit if already installed
[[ -d "${IRSSI_HOME}" ]] && (exit 0)

# install dependencies
apk add --no-cache \
	wget \
	dtach \
	geoip \
	irssi \
	irssi-perl \
	perl \
	perl-dev \
	ncurses-dev \
	gcc \
	g++ \
	autoconf \
	automake \
	make \
	perl-archive-zip \
	perl-net-ssleay \
	perl-digest-sha1 \
    php7-sockets \
    php7-json \
    php7-xml

# install perl modules
perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'
curl -L http://cpanmin.us | perl - App::cpanminus
cpanm HTML::Entities XML::LibXML JSON JSON::XS
