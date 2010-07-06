#!/bin/bash

if [ -f $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

if [ -f /etc/environment ]; then
    . /etc/environment
fi

# TODO why doesn't this work as daemon in /etc/rc.conf ?
xbindkeys

# pretend that a non-reparenting window manager is running that the XToolkit/XAWT backend can recognize
wmname LG3D

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# start xflux; warmer night-time light temperatures
# (don't; it's 32bit and won't run here)
#/home/murray/apps/xflux/xflux.sh

# update dwm status bar
while sleep 5s; do
  xsetroot -name "$(/home/murray/.dwmsb)"
done &

# fetch mail for dwm status bar
while sleep 5m; do
  /home/murray/.dwmsb-mail
done &

# change background every once in a while
# while sleep 1h; do
#   xsetbg $(/home/murray/.nextbg)
# done &

# or just set the slim bg
#xsetbg /usr/share/slim/themes/default/background.jpg

# or fetch and set one of the earth
xsetbg -at 0,15 /home/murray/.bg
while sleep 2h; do
  wget -O .bg http://static.die.net/earth/mercator/1600.jpg
#if test $status -eq 0
#  
#
  mogrify -resize 1443x800 .bg
  xsetbg -at 0,15 /home/murray/.bg
done &

exec /usr/local/bin/dwm
