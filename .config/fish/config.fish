#!/usr/bin/fish
set PATH $PATH /home/murray/usr/path/git-achievements /home/murray/.gem/ruby/1.9.1/bin /opt/scala-2.8.0.final/bin

function l -d "ll shortcut"; ll $argv; end
function ll -d "Customize dirlisting"; ls -lh --group-directories-first $argv; end
function mv -d "Be verbose"; mv -v $argv; end
function cp -d "Be verbose"; cp -v $argv; end
function rm -d "Be verbose, and confirm removal"; rm -iv $argv; end
function ssh -d "Be verbose"; ssh -v $argv; end
function top -d "Use htop, not top"; htop; end
function psg -d "Grep for process"; ps aux | grep $argv; end

function pm -d "pacman"; pacman $argv; end
function pmq -d "sudo pacman -Q"; sudo pacman -Q $argv; end
function pmr -d "sudo pacman -R"; sudo pacman -R $argv; end
function pms -d "sudo pacman -S"; sudo pacman -S $argv; end
function pmss -d "pacman -Ss"; pacman -Ss $argv; end
function pmsyu -d "sudo pacman -Syu"; sudo pacman -Suy $argv; end

function ec -d "Add emacs buffer"; emacsclient -n; end
function e -d "Start emacs"; emacs -nw; end
function m -d "mplayer shortcut"; mplayer $argv; end
function p -d "Shortcut to pdf-viewer"; xpdf $argv &; end
function r -d "Shortcut to ranger"; ranger $argv; end

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
  ifconfig | grep "inet addr"
  python -m SimpleHTTPServer
end

function checkip -d "Print this machines external IP address"
  wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d\  -f 6 | cut -d\< -f 1;
end

function record -d "Record from soundcard output and save the result as mp3"
  arecord -f cd -d 7200 | lame -h - ~/out.mp3
  echo Saved file to ~/out.mp3
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
  else
    echo "There is no ~/.ssh/id_rsa.pub, please generate your keys with 'ssh-keygen'"
  end
end

function x -d "Extract files based on file extension"
  for arg in $argv
    if not test -f $arg
      echo "No such file '$arg'"
      return 1
    end

    switch $arg
      case '*.tar'
        check_tarbomb $arg
        if not test $status -eq 0
          return 1
        end
        tar xvf $arg
      case '*.tar.gz'
        check_tarbomb $arg
        if not test $status -eq 0
          return 1
        end
        tar xzvf $arg
      case '*.tgz'
        check_tarbomb $arg
        if not test $status -eq 0
          return 1
        end
        tar xzvf $arg
      case '*.tar.bz2'
        check_tarbomb $arg
        if not test $status -eq 0
          return 1
        end
        tar xjvf $arg
      case '*.tbz2'
        check_tarbomb $arg
        if not test $status -eq 0
          return 1
        end
        tar xjvf $arg
      case '*.tar.xz'
        check_tarbomb $arg
        if not test $status -eq 0
          return 1
        end
        tar xJvf $arg
      case '*.txz'
        check_tarbomb $arg
        if not test $status -eq 0
          return 1
        end
        tar xJvf $arg
      case '*.gz'
        gunzip -v $arg
      case '*.bz2'
        bunzip2 -v $arg
      case '*.rar'
        unrar x $arg
      case '*.zip'
        unzip $arg
      case '*.jar'
        jar xvf $arg
      case '*.Z'
        uncompress $arg
      case '*'
        echo "The file extension of '$arg' is not recognized by this script"
    end
  end
end

function check_tarbomb -d "Warn if specified tar is suspected to be a tarbomb"
  # first, check the file size
  if test (du -b $argv | awk '{print $1}') -gt 50000000 # 50MB
    echo "$argv is over 50MB, skip tarbomb check? (y/N) "
    read confirm
    if test $confirm = "y"
      return 0
    end
  end

  echo "Checking for tarbomb, please wait..."
  # search for multiple root dirs
  if test (tar tf $argv | sed 's/^\.\///' | grep "/" | sed 's/\/.*//' | uniq | wc -l) -gt 1
    echo "Warning: $argv contains more than one root directory! Really continue? (y/N) "
    read confirm
    if test $confirm != "y"
      return 1
    end
  end

  # test for absolute paths
  if not test (tar tf $argv | grep -c "^/") -eq 0
    echo "Warning: $argv contains absolute paths! Really continue? (y/N) "
    read confirm
    if test $confirm != "y"
      return 1
    end
  end

  # search for files in root dir
  if not test (tar tf $argv | grep "/" -vc) -eq 0
    echo "Warning: $argv contains files in root dir! Really continue? (y/N) "
    read confirm
    if test $confirm != "y"
      return 1
    end
  end

  set acceptOverwriting 0

  for name in (tar tf $argv)
    # check that no files or folders are overwritten
    if test $acceptOverwriting -eq 0
      test -e $name
      if test $status -eq 0
        echo "Warning: This would overwrite existing file/folder '$name'! Really continue? (a/y/N) "
        read confirm
        if test $confirm = "a"
          set acceptOverwriting 1
        else
          if test $confirm != "y"
            return 1
          end
        end
      end
    end
  end

  echo "Archive passed tarbomb tests, extracting..."
  return 0
end

function git -d "Direct git through git-achievements"
  /home/murray/usr/path/git-achievements/git-achievements $argv
end

function xpc -d "Get xprop instance, class and title";
xprop |awk '
    /^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
    /^WM_NAME/{sub(/.* =/, "title:"); print}'
end

function wine -d "Reminder";
  echo "Hei søtnos, du har glemt at du ikke gadd å kompilere wine for 64-bit arkitektur :)";
end

function vipw -d "Edit my encrypted password file";
  set lastdir $PWD
  and cd ~/usr/path/pwkeeper/
  and scala no.kvikshaug.pwkeeper.Pwkeeper decrypt
  and touch tmp
  set modified (stat -c \%y tmp)
  and vim tmp
  and if test (stat -c \%y tmp) != $modified
    scala no.kvikshaug.pwkeeper.Pwkeeper encrypt
  else
    echo "No modifications."
  end
  /bin/rm -f tmp
  cd $lastdir
end

function feh -d "Start feh, assuming some options";
  # if no arguments, start in current dir
  if test "$argv" = ""
    /usr/bin/feh -.F -d -Sname .
  # if some arguments, let user specify dir
  else
    /usr/bin/feh -.F -d -Sname $argv
  end
end


# Override the shell prompt
function fish_prompt --description 'Write out the prompt'

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  switch $USER

    case root

    if not set -q __fish_prompt_cwd
      if set -q fish_color_cwd_root
        set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
      else
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
      end
    end

    printf '%s@%s %s%s%s# ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

    case '*'

    if not set -q __fish_prompt_cwd
      set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    # git prompt
    set gitprompt (git symbolic-ref HEAD 2>/dev/null | sed 's/refs\/heads\///g')
    if not test -z $gitprompt
      set gitprompt (set_color "cyan")" $gitprompt"(set_color "yellow")
      # stashed changes?
      git rev-parse --verify refs/stash >/dev/null 2>&1
      if test $status -eq 0
        set gitstashed "\$"
      end
      # unstaged changes?
      git diff --no-ext-diff --ignore-submodules --quiet --exit-code
      if test $status -ne 0
        set gitunstaged "*"
      end
      # staged changes?
      git diff-index --cached --quiet --ignore-submodules HEAD --
      if test $status -ne 0
        set gitstaged "+"
      end
    end

    printf '%s@%s %s%s%s%s%s%s%s> ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) $gitprompt $gitstashed $gitunstaged $gitstaged "$__fish_prompt_normal"

  end

end

