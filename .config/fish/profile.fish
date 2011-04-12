#!/usr/bin/fish

# This is just copied from /etc/profile{,.d/} and will have to be updated as the profile is updated

# /etc/profile
set -x PATH "/usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin"

# /etc/profile.d/glib2.sh
set -x G_BROKEN_FILENAMES 1

# /etc/profile.d/gpm.sh
# ?

# /etc/profile.d/jdk.sh
set -x J2SDKDIR /opt/java
set -x PATH $PATH /opt/java/bin /opt/java/db/bin
set -x JAVA_HOME /opt/java
set -x DERBY_HOME /opt/java/db

# /etc/profile.d/jre.sh
set -x PATH $PATH /opt/java/jre/bin
#set -x JAVA_HOME $JAVA_HOME /opt/java/jre ?

# /etc/profile.d/locale.sh
set -x LANG en_US.UTF8

# /etc/profile.d/maven.sh
set -x MAVEN_OPTS -Xmx512m
set -x M@_HOME /opt/maven
set -x PATH $PATH $M2_HOME/bin

# /etc/profile.d/perlbin.sh
if test -d /usr/bin/site_perl
  set -x PATH $PATH /usr/bin/site_perl
end

if test -d /usr/lib/perl5/site_perl/bin
  set -x PATH $PATH /usr/lib/perl5/site_perl/bin
end

if test -d /usr/bin/vendor_perl
  set -x PATH $PATH /usr/bin/vendor_perl
end

if test -d /usr/lib/perl5/vendor_perl/bin
  set -x PATH $PATH /usr/lib/perl5/vendor_perl/bin
end

if test -d /usr/bin/core_perl
  set -x PATH $PATH /usr/bin/core_perl
end

# /etc/profile.d/xorg.sh
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_DIRS /usr/share/ /usr/local/share/ $XDG_DATA_DIRS
set -x XDG_CONFIG_DIRS /etc/xdg $XDG_CONFIG_DIRS

