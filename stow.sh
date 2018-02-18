#!/bin/bash
for dir in $(find -path './[^.]*' -prune -type d | sed 's/\.\///')
do
  stow -v "$dir"
done

# explicit xconf links
stow -v -d ./xconf -t .. .xconf
