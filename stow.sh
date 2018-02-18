#!/bin/bash
for dir in $(find -path './[^.]*' -prune -type d | sed 's/\.\///')
do
  stow "$dir"
done

# explicit xconf links
stow -d ./xconf -t .. .xconf
