#!/usr/bin/fish
set PATH $PATH /home/murray/apps/git-achievements /home/murray/apps/showoff-krisb/bin

function l -d "ll shortcut"; ll $argv; end
function ll -d "Customize dirlisting"; ls -lh --group-directories-first $argv; end
function mv -d "Be verbose"; mv -v $argv; end
function cp -d "Be verbose"; cp -v $argv; end
function rm -d "Be verbose, and confirm removal"; rm -iv $argv; end
function ssh -d "Be verbose"; ssh -v $argv; end
function ag -d "Shortcut for ack-grep"; ack-grep $argv; end

function sagi -d "Shortcut for sudo apt-get install"; sudo apt-get install $argv; end
function acs -d "Shortcut for searching the apt-cache"; apt-cache search $argv; end
function ac -d "Shortcut for the apt-cache command"; apt-cache $argv; end

function shelter -d "Connect to shelter when inside of NAT"; ssh -p 23232 as@shelter; end

function scpsyspub -d "scp files to my sysrq public_html directory"
  scp $argv murray@sysrq.no:~/public_html/
end

function mkcd -d "mkdir AND cd to it in one go!"
  mkdir $argv
  if test $status = 0
    cd $argv
  end
end

function servedir -d "Serve files of cwd"
  ifconfig | ag "inet addr"
  python -m SimpleHTTPServer
end

function login -d "Logon WLAN using the hp-auth script"
  /home/murray/apps/hp-auth/hp-auth.py -i
end

function checkip -d "Print this machines external IP address"
  wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d\  -f 6 | cut -d\< -f 1;
end

function jazz -d "Launch VLC with the sky.fm smooth jazz channel :)"
  vlc http://www.sky.fm/listen/smoothjazz/64k.pls\?5c906b6f97d384e &
end

function record -d "Record from soundcard output and save the result as mp3"
  arecord -f cd -d 7200 | lame -h - ~/Desktop/out.mp3
  echo Saved file to ~/Desktop/out.mp3
end

function sendkey -d "Send ssh public key to some remote host"
  if test -f ~/.ssh/id_rsa.pub
    if test (count $argv) -lt 2
      set port 22
    else
      set port $argv[2]
    end
    if test (count $argv) -gt 0
      ssh $argv[1] -p $port "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
    end
  end
end

function x -d "Extract files based on file extension"
  for arg in $argv
    if test -f $arg
      switch $arg
        case '*.tar.bz2'
	  tar xjvf $arg
        case '*.tar.gz'
	  tar xzvf $arg
        case '*.bz2'
	  bunzip2 -v $arg
        case '*.rar'
	  unrar x $arg
        case '*.gz'
	  gunzip -v $arg
        case '*.tar'
	  tar xvf $arg
        case '*.tbz2'
	  tar xjvf $arg
        case '*.tgz'
	  tar xzvf $arg
        case '*.zip'
	  unzip $arg
        case '*.jar'
	  jar xvf $arg
        case '*.Z' 
	  uncompress $arg
        case '*'
          echo "'$arg' is not a valid file"
      end
    end
  end
end

function git -d "Direct git through git-achievements"
  /home/murray/apps/git-achievements/git-achievements $argv
end

