#!/bin/bash
DATE=$(date +"%Y-%m-%d_%H%M")
REPO="/home/pi/git/mikhaidn/InternetOfThingsCS498/Labs/Lab1-Self-Driving-Car-Base/images"
raspistill "$@" -vf -hf -o ${REPO}/$DATE.jpg 
