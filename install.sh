#!/bin/bash

shell_checker () {
  ppid=$(ps -o ppid -p $$ | tail -n 1)
  ps -p $ppid | tail -n 1 | awk '
  match($0,/bash|zsh|fish|tcsh/) {
    print substr($0,RSTART,RLENGTH)
  }'
}

shell=$(shell_checker)
echo $shell
