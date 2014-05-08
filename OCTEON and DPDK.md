####Cavium OCTEON与DPDK(Intel data plan develop kit)   

转载请保留原出处以及作者联系方式，谢谢！ylmaisiyuan@163.com    
本文网易云笔记链接，     
http://note.youdao.com/share/?id=248a6e3b877824484a02b507f69ccf84&type=note    
本文新浪博客链接，http://blog.sina.com.cn/s/blog_6b0d60af0101cu1z.html    

OCTEON专为包处理而设计，有针对性地设计了大量硬件加速单元。其芯片设计团队曾设计Alpha芯片，在处理器设计本身也是很有水平。DPDK是在Intel X86架构以及Linux环境上的一套包处理软件解决方案。概括地讲包含几个主要方面，硬件访问层，用户空间的轮询模式驱动，mempool Lib，Ring Lib，mbuf Lib，Timer Lib。后面4个都是library，纯软件的。还有其它一些纯软件库以及X86架构特有的支持。

先说一些个人主观的感觉。我是先使用的OCTEON，后接触DPDK，所以不免有偏颇之处。插入一下DPDK的历史，DPDK是6Wind公司研发，6Wind最先把自己的软件移植在OCTEON上，然后出于移植到X86的需要，就照葫芦画瓢搞了一套DPDK。所以，如果熟悉OCTEON的话，看懂DPDK也就不费一袋烟的功夫。

OCTEON是一个专用处理器，DPDK尝试在一个通用处理器上实现OCTEON上做过的事情，所以对比分析对于系统的理解非常有意思。    

OCTEON的manual难读，但是API简洁；DPDK的guide易读，但是API比较烦。觉得主要是X86没有OCTEON纯粹和优美。OCTEON里面把事情都抽象得恰到好处，所以这个抽象的过程很让人头疼，但是一旦把抽象模型建立好了，API就很纯粹，很优美。比如DPDK的mempool就很拖泥带水，OCTEON的FPA就很干脆利落。FPA就是FPA，很单纯，所以可以在软硬件之间互动。DPDK mempool的初始化竟然还要提供两个回调函数，晕。

内存管理OCTEON SE环境中，默认情况下全局变量是核本地的，要在核间共享的全局数据需要用CVMX_SHARED宏定义来明确定义。DPDK在各个核上跑的是线程，通过pthread setaffinity调用绑定到不同核上，因此，我的理解是，全局变量默认是核间共享的。

mempool与FPAmempool中的free object/buffer是通过ring来管理的，这个大概是为了借助ring的可以被多核同时操作的特性，来达到mempool可以被多核/多线程操作的目的。但是这样ring就占用了额外的内存，而且DPDK的ring是fixed size的。另外，mempool还设计了cache机制，以便减少访问ring的频率，最终是为了减少lock冲突。因为DPDK的ring不是完全的无锁设计。

那么在OCTEON的FPA中是如何解决上述问题的呢。首先，FPA是一个IO单元，对FPA的请求都可以通过一个IO读写操作来完成，包括来自软件(也就是core)和硬件(core以外的硬件单元PIP,PKO等)的请求都会被底层硬件排好序，因为硬件总线上不能同时传送两个请求，所以请求是一个跟一个来的，也就是相当于加了锁。所以FPA单元内部实现就无需考虑锁的问题，只管把buffer管理好就行了。FPA用了一个很聪明的办法，就是，把free buffer的管理信息保存在free buffer中，一个字节的内存都不会浪费。而且，FPA的pool容量不存在任何限制，运行过程中也可以往里增加新的free buffer，因为其内部管理通过list而不是数组/array。甚至可以把一个pool的buffer释放到另一个pool，只要这两个pool的buffer大小相同。FPA硬件支持预取操作，core发出预取操作，FPA把buffer地址送到core的scratch memory(data cache的一部分，也即是L1 cache)，因此请求free buffer的代价仅仅是1个cycle。

插入一点，无论软件实现pool还是FPA实现，某个pool中管理的buffer并不要求来自于同一片连续内存。     
 
另外，DPDK的mempool考虑到内存系统的优化，针对DRAM的channel、Rank、DIMM数量把free object的首地址做了专门的对齐，使得相邻的两个object/buffer不在同一个channel:Rank:DIMM上。这样可以把负载分配到多个channel和Rank，但是仍然有两个问题。第一，buffer不一定是顺序释放的，也就是说，程序运行一段时间后，对buffer的访问顺序可能是1,3,5，而不一定是1,2,3,4,5；第二，在多核环境中，系统中可能有多个mempool，单个mempool对内存的优化可能会互相抵消。

针对内存访问的问题，OCTEON在DRAM控制器中做了优化。首先，OCTEON是一个多核环境，同时会有很多DRAM访问请求。DRAM根据channel等信息自动对请求做排序和乱序处理。这个对软件是完全透明的。估计Intel的处理器也会做类似的优化。

废了一袋烟的功夫，改天再写。to be continued...

PIP/PKO与rte_ether     

说X86的网络接口就不能不提这堆缩写了，如果没有了这堆feature，那么X86做包处理就没戏了。并不是每个feature都同时需要。     
RSS, Receive Side Scaling    
VMDQ, Virtual Machine Device queue     
DCB, Data Center Bridging, guarantee lossless delivery, congestion notification, priority-based flow control, and priority groups.
DCA, Direct Cache Access    

Intel ethernet controller无论收发包，free buffer管理都是采用descriptor ring的方式，这样带来一个问题，就是，软件需要考虑何时向哪个port的receive ring中添加buffer。如果添加得多，添加到某端口receive ring的buffer不能被其它端口共享，造成浪费；如果添加得少，就可能造成瞬间的buffer耗尽而丢包。很难平衡，最简单还是多浪费内存了事。OCTEON中，PIP收到报文后才从FPA申请free buffer，PIP中只预取少量free buffer，所以free buffer任何时候都可以为所有端口和所有软硬件单元候命。

在OCTEON中，PIP收包放入POW队列，core只管从那个group接收报文/wqe，而不是直接请求某个端口/port的报文，所以只要有报文/消息/wqe要处理就不会出现无效的轮询。在X86上，不可避免地需要挨个端口轮询，不管端口有没有收到报文。

DPDK在发送报文的时候，检查此前被用过的tx descriptor是否有关联的rte_mbuf，如果有就free。这是一个很聪明的做法，既避免了中断(用于controller通知软件报文已发送完成)，又无需定时去轮询descriptor ring。由于这个buffer释放动作是纯软件的，当配合DPDK的indirect buffer使用时，就很容易解决多播中遇到的报文data buffer释放的问题。发送报文API是否有考虑到这一点还得等待查看代码。

在OCTEON中，软件可以选择让硬件释放buffer或者发送完成后通知软件，再由软件来释放buffer。针对多播的问题，要么选择copy报文，要么做引用计数器，但是硬件不能理解引用计数器，所以如果用引用计数器就得软件来释放buffer。PKO通知软件发送完成的方法有两种，一是内存地址置零，这需要软件轮询或查询，二是PKO送出一个wqe，这个感觉有掉绕，为了解决buffer释放问题，还得需要另一个wqe。不管那种方法，都不太方便，在新的OCTEON上是否有解决这个问题，那位清楚的请告知。

Timer DPDK的timer实现原理没有在文档中描述。不过有一点是明确的，timer依赖于lcore的软件周期性地调用rte timer manage()函数来检查是否有timer超时，这个造成了跟轮询收包同样的问题，浪费CPU资源，不过也只能这样，确实没有什么好办法。至于实现算法有待分析代码，这个也跟效率有直接关系。

看了DPDK timer的实现代码，是效率非常低的list数据结构，每次都要重头到尾地遍历，我无语了。没办法，只好自己按照OCTEON的timer算法实现了一个软的。

同样由于受益于硬件timer模块和POW单元，OCTEON中的timer可以同时保证精度和效率，无可挑剔。     

OCTEON通过POW单元统一管理所有消息/报文，core使用唯一的get_work接口处理所有事情，这样做有几方面好处，第一是避免无效轮询造成的CPU浪费，第二是优先级可以集中同时约束不同种类的事情。想象一下，如果用单独的接口分别轮询收包和timer，要实现高优先级的timer消息优先被处理，低优先级timer消息与接收的报文统一按发生的时间顺序处理，这是一个多么麻烦和费CPU的事情。

Intel DPDK timer算法分析    

三个List，pending是已经开始但是还没有到时的定时器列表，expired是已经到时了等待处理的定时器列表，done是已经处理完的定时器列表。已经处理完的含义是其关联的callback被调用过。

由于三个List采用的是普通的链表结构，相关代码很容易理解，也由于同一个原因，这种timer在实际项目中不能说一点意义没有，只能说其意义接近零，因此就不存在详细分析的必要。令人失望至极。作者不是水平太低就是不愿意把好东西分享出来。BTW，List操作的相关宏定义在代码中没有找到。

没办法，只能自己再费一袋烟的功夫做一个真正好使的timer。不过可以在DPDK timer的基础之上改造，这样工作量可以减到最低。    


DPDK里面疑惑的地方    

1. 为什么example中，RX descriptor比TX descriptor少？    
#define RTE_TEST_RX_DESC_DEFAULT 128    
#define RTE_TEST_TX_DESC_DEFAULT 512    

2. example中竟然单独用unsigned定义变量，没有int，这样规范吗？这样定义出来到底是几位的？    

Q&A

热情的长风2013-04-17 15:20:10[回复] [删除] [举报]
支持永龙2372，我对其硬件访问层比较感兴趣：如何在用户态直接收包的？能绕过内核？我觉得这是性能中很重要的问题，其他的库，都是浮云。。
>> 在用户态能访问寄存器以及rx/tx descriptor ring就可以收发包了，这个Linux是支持的，比如mmap技术。BTW，DPDK只是利用了Linux的一些现成技术。这个在tilera上都是这么用的，OCTEON的SDK也支持这种模式。其它的实现对性能也很重要，比如poll mode driver。引用一位朋友前几天说的话，很多个小优化最终形成很大的差距。


转载请保留原出处以及作者联系方式，谢谢！ylmaisiyuan@163.com，
本文网易云笔记链接，
http://note.youdao.com/share/?id=248a6e3b877824484a02b507f69ccf84&type=note
本文新浪博客链接，http://blog.sina.com.cn/s/blog_6b0d60af0101cu1z.html
