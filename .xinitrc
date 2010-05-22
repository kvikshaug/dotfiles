#!/bin/bash

export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"

if [ -f $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

if [ -f /etc/environment ]; then
    . /etc/environment
fi

# start xbindkeys daemon (should maybe be done in some init script instead)
xbindkeys

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# start xflux; warmer night-time light temperatures
/home/murray/apps/xflux/xflux.sh

# update dwm status bar
while true; do
  xsetroot -name "$(/home/murray/.dwmsb)"
  sleep 1m
done &

# change background every once in a while
# while sleep 1h; do
#   xsetbg $(/home/murray/.nextbg)
# done &
xsetbg /usr/share/slim/themes/default/background.jpg

exec dwm
