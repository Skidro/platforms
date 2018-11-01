#!/bin/bash

cores=`seq 0 7`

# Turn on fan for safety"
printf "%-20s: " "Fan"
cat /sys/kernel/debug/tegra_fan/target_pwm

for core in ${cores[@]}; do
	printf "Core-%-15d: " ${core}
	cat /sys/devices/system/cpu/cpu$core/online
	printf "%-20s: " "Governor"
	cat /sys/devices/system/cpu/cpu$core/cpufreq/scaling_governor
	printf "%-20s: " "Min-Freq"
	cat /sys/devices/system/cpu/cpu$core/cpufreq/cpuinfo_min_freq
	printf "%-20s: " "Max-Freq"
	cat /sys/devices/system/cpu/cpu$core/cpufreq/cpuinfo_max_freq
	printf "%-20s: " "Cur-Freq"
	cat /sys/devices/system/cpu/cpu$core/cpufreq/cpuinfo_cur_freq
	echo
done

printf "%-20s: " "RT-Throttle"
cat /proc/sys/kernel/sched_rt_runtime_us
echo
