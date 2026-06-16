#!/usr/bin/env bash

# show 256 color pallete

for x in {0..15}; do
  for y in {0..15}; do
    n=$((x*16+y))
    printf "\e[48;5;%dm %3d\e[0m" $n $n
  done
  echo
done
