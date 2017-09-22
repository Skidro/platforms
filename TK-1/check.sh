#!/bin/bash

# This script displays the current state of the machine
# ONLY FOR TEGRA K1
# MUST BE ROOT!

# Display cpu-quiet
# When cpu-quiet is enabled, the cpu cores turn off by default
# when load is low; to conserve power
printf "\n%-20s : " "CPU Quiet"
cat /sys/devices/system/cpu/cpuquiet/tegra_cpuquiet/enable;

# Display SCHED_RT throttling value
printf "%-20s : " "RT Throttling"
cat /proc/sys/kernel/sched_rt_runtime_us;

# Display whether L2 Cache Prefetcher
printf "%-20s : " "L2-Prefetch-Disable"
lsmod | grep "l2_prefetch_control"
printf "\n"

# Display cpu status 
printf "\n========= CPU Stats\n"
cd /sys/devices/system/cpu/;
for c in `seq 0 3`; do
	if [ -f cpu$c/cpufreq/scaling_governor ]; then
		printf "Core-%-15s : " "$c";
		cat cpu$c/cpufreq/scaling_governor;
	else
		printf "Core-%-15s : offline\n" "$c";
	fi
done

# Display system clock rates
printf "\n========= Clock Stats\n"
cd /sys/kernel/debug/clock/;

# GPU
printf "%-20s : " "GPU Clock"
cat override.gbus/rate;
printf "%-20s : " "GPU State"
cat override.gbus/state;

# EMC
printf "%-20s : " "EMC Clock"
cat override.emc/rate;
printf "%-20s : " "EMC State"
cat override.emc/state;
printf "\n"
