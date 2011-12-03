#! /usr/bin/env fish
# fish virutalenv functions copyright (C) 2008 Nicholas Pilon
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    For a copy of the GNU GPL, see <http://www.gnu.org/licenses/>.
#
# To install: copy this file into ~/.config/fish/ and add the following
#  line to your config.fish:
# . ~/.config/fish/virtualenv.fish
#
# Once installed, use ve-start in your virtualenv directory to start using
#  the virtualenv, and ve-stop to stop using it.

function ve-stop --description 'Stop using a virtualenv'
    if test -n "$_OLD_VIRTUAL_PATH"
        set -gx PATH $_OLD_VIRTUAL_PATH
        set -e _OLD_VIRTUAL_PATH
    end
    if test -n "$_OLD_VIRTUAL_FISH_PROMPT_HOSTNAME"
        set -gx __fish_prompt_hostname $_OLD_VIRTUAL_FISH_PROMPT_HOSTNAME
        set -e _OLD_VIRTUAL_FISH_PROMPT_HOSTNAME
    end
    set -e VIRTUAL_ENV
end

function ve-start --description 'Start using a virtualenv'
    if test ! -e bin -o ! -d bin
        echo Invalid virtual env: ./bin does not exist or is not a directory
        return
    end
    set -gx VIRTUAL_ENV $PWD

    set -g _OLD_VIRTUAL_PATH $PATH
    set -gx PATH $VIRTUAL_ENV/bin $PATH

    set -g _OLD_VIRTUAL_FISH_PROMPT_HOSTNAME $__fish_prompt_hostname
    if test (basename $VIRTUAL_ENV) = "__"
        # special case for Aspen magic directories
        # see http://www.zetadev.com/software/aspen/
        set -g __fish_prompt_hostname $__fish_prompt_hostname (basename (dirname $VIRTUAL_ENV))
    else
        set -g __fish_prompt_hostname "$__fish_prompt_hostname ("(basename $VIRTUAL_ENV)")"
    end
end
