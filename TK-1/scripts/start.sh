#!/bin/bash

# This script puts the machine in max-performance mode
# MUST BE ROOT!
# MUST BE USED ONLY ONCE AT STARTUP!
# ONLY FOR TEGRA K1

# Disable GUI
service lightdm stop;

# Mount the ssd to default location
mount -o rw /dev/sda1 /ssd;
sleep 1

# Disable cpu-quiet
# When cpu-quiet is enabled, the cpu cores turn off by default
# when load is low; to conserve power
echo 0 > /sys/devices/system/cpu/cpuquiet/tegra_cpuquiet/enable;

# Turn all cores on and change their frequency governors
# for max performance
cd /sys/devices/system/cpu/;
for c in `seq 0 3`; do
	if [ $c -ne 0 ]; then
		echo 1 > cpu$c/online;
	fi
	echo performance > cpu$c/cpufreq/scaling_governor;
	cat cpu$c/cpufreq/scaling_max_freq > cpu$c/cpufreq/scaling_min_freq;
done

# Tweak system clock rates
cd /sys/kernel/debug/clock/;

# GPU
echo 852000000 > override.gbus/rate;
echo 1 > override.gbus/state;

# EMC
echo 924000000 > override.emc/rate;
echo 1 > override.emc/state;

# Disable SCHED_RT throttling
echo -1 > /proc/sys/kernel/sched_rt_runtime_us;

# Disable L2 Cache Prefetcher
insmod /ssd/work/gits/platforms/TK-1/modules/l2_prefetch_control/l2-prefetch-control.ko;

# Increase the trace_printk buffer size
echo 16384 > /sys/kernel/debug/tracing/buffer_size_kb;
