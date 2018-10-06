#!/bin/bash

tools=("nmon" "tmux" "vim" "tree" "libncurses5-dev" "libjson-c-dev")

for tool in ${tools[@]}; do
	apt install ${tool};
done
