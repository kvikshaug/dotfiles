#!/usr/bin/zsh

setxkbmap us altgr-intl
xbindkeys
xmodmap $HOME/.Xmodmap
xrdb -merge ~/.Xresources

# turn off system bell
xset b off

# no screen saver
xset s off
xset -dpms

# wallpaper
while : ; do
  ~/.fehbg
  sleep 86400
done &

# Sync clipboard buffers
autocutsel -fork &

# Non-reparenting window manager for Java
# See https://wiki.archlinux.org/index.php/Java#Non-reparenting_window_managers_.2F_Grey_window_.2F_Programs_not_drawing_properly
export _JAVA_AWT_WM_NONREPARENTING=1

# set a reasonable default volume
amixer set Master unmute
amixer set Master 40

# warmer night-time screen temperatures
redshift -l 55.7:12.5 -t 6500:4400 -g 0.8 -m randr -v &

# update dwm status bar
/home/kvikshaug/bin/dwmsb

# albert launcher
albert &

# Ok, looks like we're done, fire up the wm
exec /usr/local/bin/dwm
