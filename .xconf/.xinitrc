#!/usr/bin/zsh

setxkbmap us altgr-intl
xbindkeys
xmodmap $HOME/.Xmodmap
xrdb -merge ~/.Xresources

# turn off system bell
#xset b off

# no screen saver
xset s off

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
#/usr/bin/python /home/murray/.dwmsb.py &
~/code/scripts/dwmsb/env/bin/python ~/code/scripts/dwmsb/dwmsb.py >> ~/code/scripts/dwmsb/output.log 2>&1 &

# Set wallpaper, choose between rotating (script) or just static
# /home/murray/.bg/setbg.py &
#/home/murray/.bg/earthmoon-loop.sh &

# Run prey at startup, in addition to the crontab
#sudo /home/murray/usr/path/prey/prey.sh > /var/log/prey.log

# Ok, looks like we're done, fire up the wm
exec /usr/local/bin/dwm
