#!/bin/bash

setxkbmap us altgr-intl
xbindkeys
if [ -f $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

xrdb -merge ~/.Xresources

#if [ -f /etc/environment ]; then
#    . /etc/environment
#fi

# turn off system bell
xset b off

# Start parcellite and sync clipboard buffers
/usr/bin/parcellite -n -d &
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

# pretend that a non-reparenting window manager is running that the XToolkit/XAWT backend can recognize
wmname LG3D

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# start xflux; warmer night-time light temperatures
xflux -l 59.91 -g 10.75 -k 4400

# update dwm status bar
/usr/bin/python /home/murray/.dwmsb.py &

# Set wallpaper, choose between rotating (script) or just static
#/home/murray/.bg/setbg.py &
xsetbg -border black /home/murray/.bg/img/wallpaper_01.png

# Run prey at startup, in addition to the crontab
#sudo /home/murray/usr/path/prey/prey.sh > /var/log/prey.log

# Ok, looks like we're done, fire up the wm
case $1 in
  "dwm")
    exec /usr/local/bin/dwm
    ;;

  "lxde")
    exec ck-launch-session startlxde
    ;;

  "xmonad")
    exec /usr/bin/xmonad
    ;;

  *)
    exec /usr/local/bin/dwm
    ;;
esac

