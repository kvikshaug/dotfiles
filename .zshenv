# Locale
export LANG='en_US.UTF-8'

# Desktop environment / Wayland
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
# Non-reparenting window manager for Java
export _JAVA_AWT_WM_NONREPARENTING=1

# Editors and pager
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-i -M -R -S -w -X -z-4'
export MANROFFOPT="-c"
export MANPAGER='less +Ggjk'

export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

# Docker Compose
export COMPOSE_BAKE=true

# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  path=($PYENV_ROOT/bin $path)
  eval "$(pyenv init --path)"
fi

# rubygems
if [ $commands[gem] ]; then
  path=($(gem env gempath | sed 's/:/\/bin:/' | sed 's/$/\/bin/') $path)
fi

# npm global packages
if [ -d "$HOME/.npm-global" ]; then
  path=("$HOME/.npm-global/bin" $path)
fi

# google-cloud-sdk
export CLOUDSDK_PYTHON=/usr/bin/python

# Local bin
path=(
  $HOME/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path
