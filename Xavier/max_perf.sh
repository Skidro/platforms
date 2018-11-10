#!/bin/bash

cores=`seq 0 7`
pdebug=/sys/kernel/debug
pbpmp=${pdebug}/bpmp
pemc=${pbpmp}/debug/clk/emc
t194gpuclk=/sys/devices/gpu.0/devfreq/17000000.gv11b

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

echo 1377000000 > ${t194gpuclk}/max_freq
echo 1377000000 > ${t194gpuclk}/min_freq

echo 1 > ${pemc}/mrq_rate_locked
echo 1 > ${pemc}/state
echo 2133000000 > ${pemc}/rate

echo -1 > /proc/sys/kernel/sched_rt_runtime_us
