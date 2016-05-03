##Change Hostname in Centos 7
1. hostnamectl
2. nmcli    

   hostnamectl


      [root@localhost ~]# hostnamectl    
      Static hostname: vfpc1   
            Icon name: computer-vm
              Chassis: vm
           Machine ID: f32e0af35637b5dfcbedcb0a1de8dca1
              Boot ID: 3650a995817640089309d3c58351b5a7
       Virtualization: kvm
     Operating System: CentOS Linux 7 (Core)
          CPE OS Name: cpe:/o:centos:centos:7
               Kernel: Linux 3.10.0-327.10.1.el7.x86_64
         Architecture: x86-64  

       [root@localhost ~]hostnamectl set-hostname <new Name> --static --pretty


    
vfpc10 ;  do  hostnamectl set-hostname vfpc10 --static --transient -H root@vfpc10 ;done
