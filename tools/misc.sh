#!/bin/sh

cur_dir="${0%/*}"

sudo apt install -y tmux
cp -vf $cur_dir/.tmux.conf ~/
