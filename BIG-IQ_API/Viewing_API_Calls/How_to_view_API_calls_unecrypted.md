I always capture traffic on the loopback 8100 port (BIG-IP or BIG-IQ) to avoid having to decrypt API calls over 443 and view API calls in clear text  

you need to do that in the Big-IP side, simply use this:  
tcpdump -s0 -ni lo port 8100 -vvv -w /var/tmp/api-trace-01.pcap  

restjavad is running in the 8100, and it receives the requests in cleartext (the SSL is offloaded by the previous stage)  
