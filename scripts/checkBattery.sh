#!/bin/bash
voltsRead = `picar-4wd power-read | tail -n 1 |grep -oE '[^ ]+$'`
# Suggested supply voltage: 6V-8.5V
# My theoretical max: 3.7V x 2 = 7.4V
max=7.4V
min=6.0V
voltsNum = ${voltsRead::-1}
maxNum=${max::-1}
minNum=${min::-1}
totalBattery=`awk -v vo=$voltsNum 'BEGIN { print vo/7.6 }'`
deltaBattery=`awk -v vo=$voltsNum 'BEGIN { print ((vo-6)/1.4)*100 }'`
echo "Total Battery: $totalBattery"
echo "Delta Left: ${deltaBattery}%"
