# delete detach sessions incase of bad shutdown
[[ -e /detach_sess/.rtorrent ]] && \
	rm /detach_sess/.rtorrent

[[ -e /detach_sess/.irssi ]] && \
	rm /detach_sess/.irssi