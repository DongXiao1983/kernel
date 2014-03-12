#### rpcbind      
[Wikipedia](http://en.wikipedia.org/wiki/Portmap)    
[Radhat doc](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/s2-nfs-methodology-portmap.html)    
    Because rpcbind provides coordination between RPC services and the port numbers used to communicate with them, it is useful to view the status of current RPC services using rpcbind when troubleshooting. The rpcinfo command shows each RPC-based service with port numbers, an RPC program number, a version number, and an IP protocol type (TCP or UDP).     
    
![](http://linux.vbird.org/linux_server/0330nfs//nfs_rpc.png)    

	# rpcinfo -p
      100021    1   udp  32774  nlockmgr
      100021    3   udp  32774  nlockmgr
      100021    4   udp  32774  nlockmgr
      100021    1   tcp  34437  nlockmgr
      100021    3   tcp  34437  nlockmgr
      100021    4   tcp  34437  nlockmgr
      100011    1   udp    819  rquotad
      100011    2   udp    819  rquotad
      100011    1   tcp    822  rquotad
      100011    2   tcp    822  rquotad
      100003    2   udp   2049  nfs
      100003    3   udp   2049  nfs
      100003    2   tcp   2049  nfs
      100003    3   tcp   2049  nfs
      100005    1   udp    836  mountd
      100005    1   tcp    839  mountd
      100005    2   udp    836  mountd
      100005    2   tcp    839  mountd
      100005    3   udp    836  mountd
      100005    3   tcp    839  mountd    


aaaaaaaaa


####
