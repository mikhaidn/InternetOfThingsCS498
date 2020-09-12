#!/bin/bash
voltsRead=`picar-4wd power-read | tail -n 1 |grep -oE '[^ ]+$'`
# Suggested supply voltage: 6V-8.5V
# My theoretical max: 3.7V x 2 = 7.4V
# Working range: 6V-7.4V
curV=${voltsRead::-1}

# total = currentVoltage / theoreticalMaxV
totalBattery=`awk -v vo=$curV 'BEGIN { print vo/7.4 }'`

# DeltaV = 7.4 - 6 = 1.4
# DeltaRemaining = curV/DeltaV
deltaBattery=`awk -v vo=$curV 'BEGIN { print ((vo-6)/1.4)*100 }'`
echo "Total Battery: $totalBattery"
echo "Delta Left: ${deltaBattery}%"
