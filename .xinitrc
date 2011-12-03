#!/bin/bash

# US layout with altgr dead keys
setxkbmap us altgr-intl

if [ -f $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

#if [ -f /etc/environment ]; then
#    . /etc/environment
#fi

# turn off system bell
xset b off

# start xbindkeys
xbindkeys

# pretend that a non-reparenting window manager is running that the XToolkit/XAWT backend can recognize
#wmname LG3D

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# start xflux; warmer night-time light temperatures
xflux -l 59.91 -g 10.75 -k 4400

# update dwm status bar
/usr/bin/scala -cp /home/murray/code/jvmlib/joda-time-1.6/joda-time-1.6.jar:/home/murray/.dwmsb/bin/ StatusBar &

# Start background script
/home/murray/.bg/setbg.py &

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

