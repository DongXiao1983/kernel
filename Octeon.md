#### Intruduction    

[http://http://mandetech.com/2011/09/05/32-core-octeon-from-cavium/](http://http://mandetech.com/2011/09/05/32-core-octeon-from-cavium/ "Link")     

It is designed to take advantage of packet and flow parallelism and exhibits linear performance scaling with the number of cores. This chip has 32 MIPS64 cores running at 1.5 GHz, each with separate I- and D-caches and a hardware accelerator for cryptographic operations. On-board peripherals include 4 separate DDR3 controllers, RAID 5/6, 20 SERDES for serial communications to other parts of the system, 4 MB of shared L2 cache and an internal crossbar switch for core to core data transfers. The total chip uses 800 M transistors in a 65 nm process.  
      
The CPU cores have a 8-stage pipeline with a dual-issue, in-order execution flow that provides deterministic performance. The 37K, 37 way instruction cache includes a 2048 x2 branch prediction unit and a 256 jump prediction unit. This highly associative L1 cache have a miss rate equivalent to much larger caches and includes automatic error correction. The L1to L2 transfers are write-through and the L2 to DRAM is write-back.   

**The chip maintains L1-L2 coherence with a write-through, write and validate coherence protocol and the L2 controller is the coherence point. The L2 control connects to the crossbar and connects to 4 octal groups of cores. Page-wise hints eliminate write-buffer flushes of private data. In addition to the standard CPU functions, the cores have an asynchronous security accelerator.**   

Power management is on a per-CPU basis through dynamic, programmable power thresholds over 256-1024 clock cycles. The thresholds are set in a register and can be closed loop through a thermal sensor or open loop. Voltage and frequency can be scaled to meet performance and power requirements. Power managed performance is several times better than the previous generation Octeon chips.     
 
Integrated co-processors include packet, TCP, security, and compression/decompression. The chip can saturate one of its 40 Gb pipes with less than 5 cores. IPSEC takes 16 cores to fill a 40 Gb pipe. The large number of high-speed I/Os and the core performance means that the chip can handle large volumes of traffic with, or without encryption.
