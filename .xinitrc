#!/bin/bash

# US layout with altgr dead keys
setxkbmap us altgr-intl

if [ -f $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

#if [ -f /etc/environment ]; then
#    . /etc/environment
#fi

# start xbindkeys
xbindkeys

# pretend that a non-reparenting window manager is running that the XToolkit/XAWT backend can recognize
#wmname LG3D

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# start xflux; warmer night-time light temperatures
# (don't; it's 32bit and won't run here)
#/home/murray/apps/xflux/xflux.sh

# update dwm status bar
/usr/bin/scala -cp /home/murray/code/jvmlib/joda-time-1.6/joda-time-1.6.jar:/home/murray/.dwmsb/bin/ StatusBar &

# change background every once in a while
# while sleep 1h; do
#   xsetbg $(/home/murray/.nextbg)
# done &

# or just set the slim bg
#xsetbg /usr/share/slim/themes/default/background.jpg

# or fetch and set one of the earth
# xsetbg -at 0,15 /home/murray/.bg/world
# while true; do
#   sleep 2h
#   wget -O .bg/world http://static.die.net/earth/mercator/1600.jpg
#   #if test $status -eq 0
#   mogrify -resize 1443x800 .bg
#   xsetbg -at 0,15 /home/murray/.bg/world
# done &
xsetbg -center /home/murray/.bg/aperture-laboratories.jpg

case $1 in
  "dwm")
    exec /usr/local/bin/dwm
    ;;

  "lxde")
    exec ck-launch-session startlxde
    ;;

  *)
    exec /usr/local/bin/dwm
    ;;
esac

