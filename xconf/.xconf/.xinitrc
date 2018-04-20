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

# wallpaper
~/.fehbg

# Start cliboard history manager and sync clipboard buffers
/usr/bin/copyq &
# autocutsel -fork &
# autocutsel -selection PRIMARY -fork &

# Non-reparenting window manager for Java
# See https://wiki.archlinux.org/index.php/Java#Non-reparenting_window_managers_.2F_Grey_window_.2F_Programs_not_drawing_properly
export _JAVA_AWT_WM_NONREPARENTING=1

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# start xflux; warmer night-time light temperatures
xflux -l 59.91 -g 10.75 -k 4400

# update dwm status bar
/home/kvikshaug/bin/dwmsb

# Ok, looks like we're done, fire up the wm
exec /usr/local/bin/dwm
