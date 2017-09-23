obj-m += l2-prefetch-control.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
.PHONY: clean

clean:
	rm -rf *.o *~ core .depend .*.cmd *.mod.c *.ko *.order *.symvers
