    
HugePage，就是指的大页内存管理方式。与传统的4kb的普通页管理方式相比，HugePage为管理大内存(8GB以上)更为高效。本文描述了什么是HugePage，以及HugePage的一些特性。    
 
### 1. Hugepage的引入    
操作系统对于数据的存取直接从物理内存要比从磁盘读写数据要快的多，但是物理内存是有限的，这样就引出了物理内存与虚拟内存的概念。虚拟内存就是为了满足物理内存的不足而提出的策略，它是利用磁盘空间虚拟出的一块逻辑内存，这部分磁盘空间Windows下称之为虚拟内存，Linux下被称为交换空间(Swap Space)。    
 
对于这个大内存的管理(物理内存+虚拟内存)，大多数操作系统采用了分段或分页的方式进行管理。分段是粗粒度的管理方式，而分页则是细粒度管理方式，分页方式可以避免内存空间的浪费。相应地，也就存在内存的物理地址与虚拟地址的概念。通过前面这两种方式，CPU必须把虚拟地址转换程物理内存地址才能真正访问内存。为了提高这个转换效率，CPU会缓存最近的虚拟内存地址和物理内存地址的映射关系，并保存在一个由CPU维护的映射表中。为了尽量提高内存的访问速度，需要在映射表中保存尽量多的映射关系。    
 
linux的内存管理采取的是分页存取机制，为了保证物理内存能得到充分的利用，内核会按照LRU算法在适当的时候将物理内存中不经常使用的内存页自动交换到虚拟内存中，而将经常使用的信息保留到物理内存。通常情况下，Linux默认情况下每页是4K，这就意味着如果物理内存很大，则映射表的条目将会非常多，会影响CPU的检索效率。因为内存大小是固定的，为了减少映射表的条目，可采取的办法只有增加页的尺寸。因此Hugepage便因此而来。也就是打破传统的小页面的内存管理方式，使用大页面2m,4m,16m等等。如此一来映射条目则明显减少。如果系统有大量的物理内存（大于8G），则物理32位的操作系统还是64位的，都应该使用Hugepage。    
 
### 2. Hugepage的相关术语    
#### Page Table:    
A page table is the data structure of a virtual memory system in an operating system to store the mapping between virtual addresses and physical addresses. This means that on a virtual memory system, the memory is accessed by first accessing a page table and then accessing the actual memory location implicitly.    
如前所述，page table也就是一种用于内存管理的实现方式，用于物理地址到虚拟之间的映射。因此对于内存的访问，先是访问Page Table，然后根据Page Table 中的映射关系，隐式的转移到物理地址来存取数据。    
 
#### TLB:    
A Translation Lookaside Buffer (TLB) is a buffer (or cache) in a CPU that contains parts of the page table. This is a fixed size buffer being used to do virtual address translation faster.    
      CPU中的一块固定大小的cache，包含了部分page table的映射关系，用于快速实现虚拟地址到物理地址的转换。    
 
#### hugetlb:    
This is an entry in the TLB that points to a HugePage (a large/big page larger than regular 4K and predefined in size). HugePages are implemented via hugetlb entries, i.e. we can say that a HugePage is handled by a "hugetlb page entry". The 'hugetlb" term is also (and mostly) used synonymously with a HugePage (See Note 261889.1). In this document the term "HugePage" is going to be used but keep in mind that mostly "hugetlb" refers to the same concept.    
hugetlb 是TLB中指向HugePage的一个entry(通常大于4k或预定义页面大小)。 HugePage 通过hugetlb entries来实现，也可以理解为HugePage 是hugetlb page entry的一个句柄。    
 
#### hugetlbfs:    
This is a new in-memory filesystem like tmpfs and is presented by 2.6 kernel. Pages allocated on hugetlbfs type filesystem are allocated in HugePages.    
一个类似于tmpfs的新的in-memory filesystem，在2.6内核被提出。 


### 3. 使用huge page的优点    
    
#### a、Not swappable    
HugePages are not swappable. Therefore there is no page-in/page-out mechanism overhead.HugePages are universally regarded as pinned.    
无需交换。也就是不存在页面由于内存空间不足而存在换入换出的问题    
 
#### b、Relief of TLB pressure    
Hugepge uses fewer pages to cover the physical address space, so the size of “book keeping” (mapping from the virtual to the physical address) decreases, so it requiring fewer entries in the TLB    
TLB entries will cover a larger part of the address space when use HugePages, there will be fewer TLB misses before the entire or most of the SGA is mapped in the SGA    
Fewer TLB entries for the SGA also means more for other parts of the address space    
减轻TLB的压力，也就是降低了cpu cache可缓存的地址映射压力。由于使用了huge     page，相同的内存大小情况下，管理的虚拟地址数量变少。    
TLB entry可以包含更多的地址空间，cpu的寻址能力相应的得到了增强。    
 
#### c、Decreased page table overhead    
Each page table entry can be as large as 64 bytes and if we are trying to handle 50GB of RAM, the pagetable will be approximately 800MB in size which is practically will not fit in 880MB size lowmem (in 2.4 kernels - the page table is not necessarily in lowmem in 2.6 kernels) considering the other uses of lowmem. When 95% of memory is accessed via 256MB hugepages, this can work with a page table of approximately 40MB in total. See also Document 361468.1.     
降低page table负载，对于普通的page，每个entry需要64bytes进行管理，对于50gb的内存，管理这些entry，需要800mb的大小
(50*1024*1024)kb/4kb*64bytes/1024/1024=800mb。     
 
#### d、Eliminated page table lookup overhead   
Since the pages are not subject to replacement, page table lookups are not required.( 消除page table查找负载)     
 
#### e、Faster overall memory performance     
On virtual memory systems each memory operation is actually two abstract memory operations. Since there are fewer pages to work on, the possible bottleneck on page table access is clearly avoided.(提高内存的整体性能)       
