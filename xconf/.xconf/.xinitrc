#!/usr/bin/zsh

setxkbmap us altgr-intl
xbindkeys
xmodmap $HOME/.Xmodmap
xrdb -merge ~/.Xresources

# turn off system bell
#xset b off

# no screen saver
xset s off
xset -dpms

# Start cliboard history manager and sync clipboard buffers
/usr/bin/copyq &
# autocutsel -fork &
# autocutsel -selection PRIMARY -fork &

# pretend that a non-reparenting window manager is running that the XToolkit/XAWT backend can recognize
wmname LG3D

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# start xflux; warmer night-time light temperatures
xflux -l 59.91 -g 10.75 -k 4400

# update dwm status bar
~/code/scripts/dwmsb/env/bin/python ~/code/scripts/dwmsb/dwmsb.py >> ~/code/scripts/dwmsb/output.log 2>&1 &

# Ok, looks like we're done, fire up the wm
exec /usr/local/bin/dwm
