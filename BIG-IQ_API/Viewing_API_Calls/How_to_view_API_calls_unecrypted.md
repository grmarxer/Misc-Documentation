I always capture traffic on the loopback 8100 port (BIG-IP or BIG-IQ) to avoid having to decrypt API calls over 443 and view API calls in clear text  

you need to do that in the Big-IP side, simply use this:  
tcpdump -ni lo port 8100 -s0 -w /var/tmp/<filename>.pcap  

restjavad is running in the 8100, and it receives the requests in cleartext (the SSL is offloaded by the previous stage)  
