1. Problem:    

	    Downloading Packages: 
	    warning: rpmts_HdrFromFdno: Header V3 RSA/SHA1 signature: NOKEY, key ID 4bd6ec30 
	    
	    Public key for puppetlabs-release-5-1.noarch.rpm is not installed      
  
2. Solutions:   

    	gpg --recv-key 4BD6EC30
    	gpg -a --export 4BD6EC30 > /opt/key.txt
    	rpm --import /opt/key.txt    
