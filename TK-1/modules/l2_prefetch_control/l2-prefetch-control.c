#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

#include <asm/cp15.h>

#define DRIVER_DESC "Disable/Enable L2 Prefetcher in Cortex-A15"

static unsigned long L2PR;
static unsigned long L2PR_MODIFIED;

static unsigned long read_l2pr(void)
{
	unsigned long local_l2pr;
	asm volatile(
	"mrc    p15, 1, %0, c15, c0, 3\n\t"
	: "=r"(local_l2pr));
	return local_l2pr;

}

static int __init cortexa15_l2_prefetch_disable(void)
{
	unsigned long prefethch_disable = 0x400;
	trace_printk(KERN_INFO "Disabling L2 Prefetcher\n");

	L2PR = read_l2pr();
        L2PR &= ~(1<<12); /* Disable Dynamic Throttling */

	printk(KERN_INFO "Default value of L2 Prefetch Register = 0x%08lx\n", L2PR);

	asm volatile(
	"mcr    p15, 1, %1, c15, c0, 3\n\t"
	"isb\n\t"
	"dsb\n\t"
	"mrc    p15, 1, %0, c15, c0, 3\n"
	: "=r"(L2PR_MODIFIED): "r"(prefethch_disable));
	trace_printk(KERN_INFO "After disabling prefetch : L2 Prefetch Register = 0x%08lx\n", L2PR_MODIFIED);
	return 0;
}

static void __exit cortexa15_l2_prefetch_enable(void)
{
	trace_printk(KERN_INFO "Enabling L2 Prefetcher\n");
	asm volatile(
	"mcr    p15, 1, %1, c15, c0, 3\n\t"
	"isb\n\t"
	"dsb\n\t"
	"mrc    p15, 1, %0, c15, c0, 3\n"
	: "=r"(L2PR_MODIFIED): "r"(L2PR));

	trace_printk(KERN_INFO "Restored to default  : L2 Prefetch Register = 0x%08lx\n", L2PR_MODIFIED);
}

module_init(cortexa15_l2_prefetch_disable);
module_exit(cortexa15_l2_prefetch_enable);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("KU-CSL");
MODULE_DESCRIPTION(DRIVER_DESC);
