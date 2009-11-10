# The default debian/ubuntu user bashrc routines

[ -z "$PS1" ] && return
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# The rest here is stuff to make me feel at home at a terminal.

# git-aware prompt: http://blog.fedora-fr.org/bochecha/post/2009/08/A-git-aware-prompt-(part2)
# PS1="$PS1$(__git_ps1)"
# git bash-completion
source .git-completion.bash

export PAGER=less
export MANPAGER=less
export BROWSER=opera
export EDITOR=vim
export VISUAL=$EDITOR
export HISTSIZE=10000
export HISTFILESIZE=10000
export GIT_PS1_SHOWDIRTYSTATE=1 # indicate uncommitted changes in prompt

# use this if fsr gems won't install properly (by root)
#export PATH=$PATH:/home/murray/.gem/ruby/1.8/bin

export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/
export JDK_HOME=$JAVA_HOME

alias ll='ls -l'
alias la='ls -la'
alias l='ls -cf'

alias mv='mv -v'
alias cp='cp -v'
alias rm='rm -iv'

alias sysrq='ssh sysrq.no'
alias hinux='ssh hinux.hin.no'
alias scabb='ssh heiatufte.net -p 23232'
alias shelter='ssh as@shelter -p 23232'
alias spittle='ssh gh.kvikshaug.no'

alias sagi='sudo apt-get install'
alias acs='apt-cache search'
alias ac='apt-cache'

alias ssh='ssh -v'
alias jazz='vlc http://www.sky.fm/mp3/smoothjazz.pls &'
alias servedir='ifconfig | grep "inet addr" && python -m SimpleHTTPServer'
alias tyvm='echo np'

function mkcd() { mkdir "$1" && cd "$1"; }
function scpsyspub() { scp $1 murray@sysrq.no:~/public_html/; }
function scpsys() { scp $1 murray@sysrq.no:~/; }
function myip() { wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1; }
function record() {
  arecord -f cd -d 7200 | lame -h - ~/Desktop/out.mp3;
  echo Saved file to ~/Desktop/out.mp3;
}
# send ssh public key to some remote host
function sendkey () {
  if [ -f ~/.ssh/id_rsa.pub ]
  then
    if [ -z $2 ]
    then
      local port="22"
    else
      local port="$2"
    fi
    if [ $# -gt 0 ]
    then
      ssh $1 -p $port 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
    fi
  fi
}
 
# extract files based on file extension
function x() {
  for arg in $@
  do
  if [ -f $arg ]
    then
      case $arg in
        *.tar.bz2)  tar xjvf $arg     ;;
        *.tar.gz)   tar xzvf $arg     ;;
        *.bz2)      bunzip2 -v $arg   ;;
        *.rar)      unrar x $arg      ;;
        *.gz)       gunzip -v $arg    ;;
        *.tar)      tar xvf $arg      ;;
        *.tbz2)     tar xjvf $arg     ;;
        *.tgz)      tar xzvf $arg     ;;
        *.zip)      unzip $arg        ;;
        *.jar)      jar xvf $arg      ;;
        *.Z)        uncompress $arg   ;;
        *)          echo "'$arg' cannot be extracted via x (extract)" ;;
      esac
    else
      echo "'$arg' is not a valid file"
    fi
  done
}
