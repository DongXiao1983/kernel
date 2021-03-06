SELinux 与强制访问控制系统    
   
SELinux 全称 Security Enhanced Linux (安全强化 Linux)，是 MAC (Mandatory Access Control，强制访问控制系统)的一个实现，目的在于明确的指明某个进程可以访问哪些资源(文件、网络端口等)。    

强制访问控制系统的用途在于增强系统抵御 0-Day 攻击(利用尚未公开的漏洞实现的攻击行为)的能力。所以它不是网络防火墙或 ACL 的替代品，在用途上也不重复。    

举例来说，系统上的 Apache 被发现存在一个漏洞，使得某远程用户可以访问系统上的敏感文件(比如 /etc/passwd 来获得系统已存在用户)，而修复该安全漏洞的 Apache 更新补丁尚未释出。此时 SELinux 可以起到弥补该漏洞的缓和方案。因为 /etc/passwd 不具有 Apache 的访问标签，所以 Apache 对于 /etc/passwd 的访问会被 SELinux 阻止。        

相比其他强制性访问控制系统，SELinux 有如下优势：    

1.控制策略是可查询而非程序不可见的。    
2.可以热更改策略而无需重启或者停止服务。    
3.可以从进程初始化、继承和程序执行三个方面通过策略进行控制。    
4.控制范围覆盖文件系统、目录、文件、文件启动描述符、端口、消息接口和网络接口。    
