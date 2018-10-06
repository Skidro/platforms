#!/bin/bash

cores=(0 3 4 5)

mount -o rw /dev/sda1 ssd
service lightdm stop

./jetson_clocks.sh

# Turn on fan for safety"
echo 255 > /sys/kernel/debug/tegra_fan/target_pwm

for core in ${cores[@]}; do
	echo performance > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu$core/cpufreq/scaling_max_freq > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_min_freq
done

echo -1 >/proc/sys/kernel/sched_rt_runtime_us
