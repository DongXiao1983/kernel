kernel
======
   
Something should know before kernel programming.

1. User space & kernel spacs    
   Depeding on which priviledges , address space and EIP a process in executing in.
2. Memory allocation     
   malloc call the brk() 
3. Processed & thread    
   The low level interface to create threads is the clone() system call.       
   The higher level interface is pthread_create().    
   Linux threading is “1-1”,not “1-N” or “M-N”.
4. Native POSIX Thread Libray    
   [Desig mamunl](http://people.redhat.com/drepper/nptl-design.pdf)    
5. Optimization    
6. Use the right abstraction layer for the job    
7. Coding style is important    
8. Alaways check for error    
9. Portability    
