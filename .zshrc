#
# Convenient aliases and defaults
#

alias l='ls'
alias ls='ls -lh --color=auto --group-directories-first --time-style=long-iso'
eval "$(dircolors --sh)"
alias la='ls -a'
alias mv='mv -v'
alias cp='cp -v'
alias ln='ln -v'
function mkcd { [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1" }
alias rm='rm -vi'
alias rmdir='rmdir -v'
alias ..='cd ..'
alias ssh='ssh -v'
alias cal='cal -m'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias dmesg='dmesg --color=always'
alias ip='ip -color=auto'
alias m='mpv'
alias gitk='gitk --all'
alias tig='tig --all'
alias dc='docker compose'
alias s='subl . && exit'
alias c='code .'
alias lo="libreoffice"
alias duf="duf --hide special"

# Default privilege escalation
alias pm='sudo pacman'
alias iftop='sudo iftop'

# SSH shortcuts
alias anton='ssh -t anton tmux -u at'
alias marvin='ssh -t marvin tmux -u at -t ali'
alias brillig='ssh -t brillig'
alias weechat='ssh -t brillig "tmux -u at -t weechat" && exit'

# Media tools
alias webcam='mpv av://v4l2:/dev/video0'
alias record_screen_full='wf-recorder'
alias record_screen_section='wf-recorder -g "$(slurp)"'
alias record_video='ffmpeg -f v4l2 -s 640x480 -i /dev/video0 out.mpg'

#
# History
#

HISTFILE=~/.zhistory
HISTSIZE=20000
SAVEHIST=20000

# Treat the '!' character specially during expansion.
setopt BANG_HIST
# Write the history file in the ':start:elapsed;command' format.
setopt EXTENDED_HISTORY
# Share history between all sessions.
setopt SHARE_HISTORY
# Expire a duplicate event first when trimming history.
setopt HIST_EXPIRE_DUPS_FIRST
# Do not record an event that was just recorded again.
setopt HIST_IGNORE_DUPS
# Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_ALL_DUPS
# Do not display a previously found event.
setopt HIST_FIND_NO_DUPS
# Do not record an event starting with a space.
setopt HIST_IGNORE_SPACE
# Do not write a duplicate event to the history file.
setopt HIST_SAVE_NO_DUPS
# Do not execute immediately upon history expansion.
setopt HIST_VERIFY
# Beep when accessing non-existent history.
setopt HIST_BEEP

#
# Prompt
#

# Pure prompt
if [ -d "$HOME/.pure" ]; then
  fpath+=($HOME/.pure)
  zstyle ':prompt:pure:git:stash' show yes
  autoload -U promptinit
  promptinit
  prompt pure
fi

# Autocorrection
setopt CORRECT

# Fuzzy finder
if [ -f '/usr/share/fzf/key-bindings.zsh' ]; then source /usr/share/fzf/key-bindings.zsh; fi
if [ -f '/usr/share/fzf/completion.zsh' ]; then source /usr/share/fzf/completion.zsh; fi

# Syntax highlighting (requires `zsh-syntax-highlighting`)
if [ -f '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]; then source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; fi

# Look for invalid command among uninstalled packages (requires `pkgfile`)
if [ -f '/usr/share/doc/pkgfile/command-not-found.zsh' ]; then source /usr/share/doc/pkgfile/command-not-found.zsh; fi

# pyenv; note that there's also a section in .zprofile to modify path.
if [ -d "$HOME/.pyenv" ]; then eval "$(pyenv init -)"; fi

# Line editor
bindkey -e
autoload edit-command-line; zle -N edit-command-line
WORDCHARS=${WORDCHARS/\//}
bindkey '^e' edit-command-line
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[3;3~" delete-word

# Tab completion
autoload -Uz compinit
# Don't check the .zcompdump file for 24 hours (using zsh's beautiful globbing).
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi;
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
setopt PATH_DIRS            # Perform path search even on command names with slashes.
setopt AUTO_MENU            # Show completion menu on a successive tab press.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB        # Needed for file modification glob modifiers with compinit.
unsetopt MENU_COMPLETE      # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor.
# Shift-tab for reverse direction
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

#
# Completion settings
# These settings are all copied from prezto. Haven't really vetted them, but they seem to work well.
#

# Defaults.
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion. But allow ignoring custom entries from static
# */etc/hosts* which might be uninteresting.
zstyle -a ':prezto:module:completion:*:hosts' etc-host-ignores '_etc_host_ignores'

zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns adm amanda apache avahi beaglidx bin cacti canna clamav daemon dbus distcache dovecot fax ftp games gdm gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust ldap lp mail mailman mailnull mldonkey mysql nagios named netdump news nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# Mutt
if [[ -s "$HOME/.mutt/aliases" ]]; then
  zstyle ':completion:*:*:mutt:*' menu yes select
  zstyle ':completion:*:mutt:*' users ${${${(f)"$(<"$HOME/.mutt/aliases")"}#alias[[:space:]]}%%[[:space:]]*}
fi

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Lastly, source machine-local environment, if any
if [ -f "${HOME}/.zshrc.local" ]; then source "${HOME}/zshrc.local"; fi
