#!/bin/bash

cores=`seq 0 7`

#service lightdm stop
./jetson_clocks.sh

# Turn on fan for safety"
echo 255 > /sys/kernel/debug/tegra_fan/target_pwm

for core in ${cores[@]}; do
	echo 1 > /sys/devices/system/cpu/cpu$core/online
	echo performance > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu$core/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_max_freq
	cat /sys/devices/system/cpu/cpu$core/cpufreq/scaling_max_freq > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_min_freq
done

echo -1 > /proc/sys/kernel/sched_rt_runtime_us
