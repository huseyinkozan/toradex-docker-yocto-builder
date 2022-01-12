#!/bin/bash

err_exit() {
  echo "$@" 1>&2
  exit 1
}

CFG=/etc/app/cpu-governor
GOV=interactive

if [ ! -f $CFG ]; then
  err_exit "File not exist: $CFG"
fi

GOV=$(cat $CFG)

OLD=$(cat "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor")

cpufreq-set -g $GOV || err_exit "Failed to set governor"

CURR=$(cat "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor")

echo "cpu governor: $OLD -> $CURR" > /dev/kmsg
echo "cpu governor: $OLD -> $CURR"

exit 0
