#!/bin/bash

NAME=""
parsed_options=$(
  getopt -n "$0" -o n -- "$@"
) || exit
eval "set -- $parsed_options"
while [ "$#" -gt 0 ]; do
  case $1 in
    (-n) NAME = ${2}_; shift 2;;
    (--) shift; break;;
    (*) exit 1 # should never be reached.
  esac
done
echo "Now, the arguments are $*"


DATE=$(date +"%Y-%m-%d_%H%M")
FILE_NAME=${NAME}${DATE}
REPO="/home/pi/git/mikhaidn/InternetOfThingsCS498/Labs/Lab1-Self-Driving-Car-Base/images"
raspistill "$@" -vf -hf -o ${REPO}/${FILE_NAME}.jpg 
