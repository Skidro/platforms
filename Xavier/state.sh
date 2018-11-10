#!/bin/bash

pBpmp=/sys/kernel/debug/bpmp
pGpu=/sys/devices/gpu.0/devfreq/17000000.gv11b

cores=`seq 0 7`

# Turn on fan for safety"
printf "%-20s: " "Fan PWM"
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

echo "===== GPU Frequencies (Hz)"
cat ${pGpu}/available_frequencies

printf "%-20s: " "GPU Cur. Frequency"
cat ${pGpu}/cur_freq
echo

echo "===== EMC Frequencies (Hz)"
cat ${pBpmp}/debug/emc/possible_rates

printf "%-20s: " "EMC Cur. Frequency"
cat ${pBpmp}/debug/clk/emc/rate
echo

printf "%-20s: " "RT-Throttle"
cat /proc/sys/kernel/sched_rt_runtime_us
echo
