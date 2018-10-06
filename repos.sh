#!/bin/bash

my_git="https://github.com/wali-ku"
repos=("GLOCK" "BWLOCK-GPU" "B2106745" "Rt-Work" "rt-app" "dotFiles")

clone_repo () {
	echo "======== Cloning ${1}"
	git clone ${my_git}/${1}.git
	echo
}

clone_other_repo () {
	echo "======== Cloning ${2}"
	git clone https://github.com/${1}/${2}.git
	echo
}

for repo in ${repos[@]}; do
	clone_repo ${repo}
done

clone_other_repo CSL-KU IsolBench
clone_other_repo mbechtel2 DeepPicar-v2
