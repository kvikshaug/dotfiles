#!/usr/bin/env sh
for dir in $(ls -d */); do
  stow -v $dir
done
