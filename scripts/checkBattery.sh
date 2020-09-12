#!/bin/bash
voltsRead=`picar-4wd power-read | tail -n 1 |grep -oE '[^ ]+$'`
# Suggested supply voltage: 6V-8.5V
curV=${voltsRead::-1}

# total = currentVoltage / theoreticalMaxV
totalBattery=`awk -v vo=$curV 'BEGIN { print vo/8.5 }'`

# DeltaV = 7.4 - 6 = 1.4
# DeltaRemaining = curV/DeltaV
deltaBattery=`awk -v vo=$curV 'BEGIN { print ((vo-6)/2.5)*100 }'`
echo "Total Battery: $totalBattery"
echo "Delta Left: ${deltaBattery}%"
