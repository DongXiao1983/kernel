##How to upgrade the kernel on CentOS    

在yum的ELRepo源中，有mainline（3.13.1）、long-term（3.10.28）这2个内核版本，考虑到long-term更稳定，会长期更新，所以选择这个版本。    

1.导入public key   

	rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org  

2.安装ELRepo到CentOS-6.5中    
  
	rpm -ivh http://www.elrepo.org/elrepo-release-6-5.el6.elrepo.noarch.rpm    
  

3.安装kernel-lt（lt=long-term）    
    
	yum --enablerepo=elrepo-kernel install kernel-lt -y   
	yum --enablerepo=elrepo-kernel install kernel-ml -y      
 
4 . 编辑grub.conf文件，修改Grub引导顺序  

	default=0    
	timeout=5    
	splashimage=(hd0,0)/grub/splash.xpm.gz    
	hiddenmenu    
	title CentOS (3.10.39-1.el6.elrepo.x86_64)    
	    root (hd0,0)    
	    kernel /vmlinuz-3.10.39-1.el6.elrepo.x86_64 ro root=/dev/mapper/vg_cloud-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=vg_cloud/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=128M rd_LVM_LV=vg_cloud/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
	    initrd /initramfs-3.10.39-1.el6.elrepo.x86_64.img    
	title CentOS (2.6.32-431.11.2.el6.x86_64)    
	    root (hd0,0)    
	    kernel /vmlinuz-2.6.32-431.11.2.el6.x86_64 ro root=/dev/mapper/vg_cloud-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=vg_cloud/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=128M rd_LVM_LV=vg_cloud/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
	    initrd /initramfs-2.6.32-431.11.2.el6.x86_64.img    
	title CentOS (2.6.32-431.el6.x86_64)    
	    root (hd0,0)    
	    kernel /vmlinuz-2.6.32-431.el6.x86_64 ro root=/dev/mapper/vg_cloud-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=vg_cloud/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=128M rd_LVM_LV=vg_cloud/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
	    initrd /initramfs-2.6.32-431.el6.x86_64.img    


5 .重启，查看内核版本号    
