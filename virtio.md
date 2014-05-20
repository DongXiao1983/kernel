[Virtio: An I/O virtualization framework for Linux] (http://www.ibm.com/developerworks/library/l-virtio/)
[Paper ] (http://ozlabs.org/~rusty/virtio-spec/virtio-paper.pdf)

####Paravirtualized drivers for kvm/Linux    

Virtio was chosen to be the main platform for IO virtualization in KVM    
The idea behind it is to have a common framework for hypervisors for IO virtualization    
More information (although not uptodate) can be found [here](http://www.linux-kvm.org/wiki/images/d/dd/KvmForum2007%24kvm_pv_drv.pdf)    
At the moment network/block/balloon devices are suported for kvm    
The host implementation is in userspace - qemu, so no driver is needed in the host.     
    
####use Virtio   
Get kvm version >= 60    
Get Linux kernel with virtio drivers for the guest     
Get Kernel >= 2.6.25 and activate (modules should also work, but take care of initramdisk)      

    CONFIG_VIRTIO_PCI=y (Virtualization -> PCI driver for virtio devices)    
    CONFIG_VIRTIO_BALLOON=y (Virtualization -> Virtio balloon driver)    
    CONFIG_VIRTIO_BLK=y (Device Drivers -> Block -> Virtio block driver)    
    CONFIG_VIRTIO_NET=y (Device Drivers -> Network device support -> Virtio network driver)    
    CONFIG_VIRTIO=y (automatically selected)    
    CONFIG_VIRTIO_RING=y (automatically selected)    
    
you can safely disable SATA/SCSI and also all other nic drivers if you only use VIRTIO (disk/nic)      

