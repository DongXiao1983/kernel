##Quick start

####Extract sources.  
> tar xf dpdk.tar.gz    
> cd dpdk    
 
#### Build libraries and kernel module (Linux headers are needed).    
> make config T=x86_64-default-linuxapp-gcc    
> make    

#### The next steps must be done as root.
#### Load kernel modules.
> modprobe uio    
> insmod build/kmod/igb_uio.ko    

#### Bind Intel devices to igb_uio.
> tools/pci_unbind.py --bind=igb_uio $(tools/pci_unbind.py --status | sed -rn 's,.* if=([^ ]*).*igb_uio *$,\1,p')        

#### Reserve huge pages memory.    
> mkdir -p /mnt/huge
> mount -t hugetlbfs nodev /mnt/huge
> echo 64 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages    

####  Set the highest frequency.
> for gov in /sys/devices/system/cpu/*/cpufreq/scaling_governor ; do echo performance >$gov ; done    

#### Run poll-mode driver test (with a cable between ports).
    build/app/testpmd -c7 -n3 -- -i --nb-cores=2 --nb-ports=2
    
    testpmdshow port stats all
    
      ######################## NIC statistics for port 0  ########################
      RX-packets: 0  RX-errors: 0 RX-bytes: 0
      TX-packets: 0  TX-errors: 0 TX-bytes: 0
      ############################################################################
    
      ######################## NIC statistics for port 1  ########################
      RX-packets: 0  RX-errors: 0 RX-bytes: 0
      TX-packets: 0  TX-errors: 0 TX-bytes: 0
      ############################################################################
    
    testpmdstart tx_first
    
    testpmdstop
    
      ---------------------- Forward statistics for port 0  ----------------------
      RX-packets: 7139974RX-dropped: 0 RX-total: 7139974
      TX-packets: 6699967TX-dropped: 0 TX-total: 6699967
      ----------------------------------------------------------------------------
    
      ---------------------- Forward statistics for port 1  ----------------------
      RX-packets: 6699967RX-dropped: 0 RX-total: 6699967
      TX-packets: 7139974TX-dropped: 0 TX-total: 7139974
  
