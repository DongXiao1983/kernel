1. Generate Radom string    
`od -t x8 -N 8 -A n< /dev/random`    

2. Trace a DNS     
`dig +trace baidu.com`    
[DNS 2014-01-21 ](http://www.freebuf.com/articles/network/24180.html)    
  

2. When fstab error cause / write-protect     
`mount / -o remount,rw`

4. show sysfs     
`systool`

4. Force insert kmod     
`insmod -f xxx.ko`

4. check kernel configure     
`zcat /proc/config.gz | grep xxxx`

4. Display kernel module parameters      
`systool`


4. Display kill signal       
`kill -l`

5. Hugetable fs       
`mount -t hugetables nodev /mnt/hugetables`  

6. SSH   
` ssh -vvv -T -l wrsroot 10.17.85.55 info `

7. netstat   
` netstat --tnulT `   

8. journalctl   
` journalctl -o json --since='2016-08-07 22:37:14' --until='2016-08-07 22:39:00' --no-pager `  

9. systemctl   
` sudo systemctl status --lines=0 quorate-monitor.service|cat `   
