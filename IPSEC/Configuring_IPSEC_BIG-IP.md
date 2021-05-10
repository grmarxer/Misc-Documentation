## Configuring BIG-IP to use IPSEC Tunnel Mode (Best Option to connect BIG-IP IPSEC to Third Party)  

### There are two configurations below:  
#### 1. IPv4 Only
#### 2. IPv6 Inside the IPv4 IPSEC tunnel
<br/>  

__Note:__ All configurations below use BIG-IP v13.1.3.5  


<br/>  

## IPv4 Only  

### IPv4 Only Lab Diagram  

![Lab Diagram](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/diagram/ipsec_lab_ipv4_only.png)  


###  This Configuration Supports IPv4 IPSEC only  

1. BIG-IP ve2-ltm-13-1-3-5.com configuration  

    [BIG-IP SCF](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve2-ltm-13-1-3-5_IPv4-only.txt)  

    [BIG-IP Parsed SCF -- ready for cut and paste](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve2-ltm-13-1-3-5_IPv4_only_parsed.txt)  

    [BIG-IP UCS](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve2-ltm-13-1-3-5.com-IPv4-only.ucs)  

2. BIG-IP ve4-ltm-13-1-3-5.com configuration

    [BIG-IP SCF](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve4-ltm-13-1-3-5_IPv4_only.txt)  

    [BIG-IP Parsed SCF -- ready for cut and paste](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve4-ltm-13-1-3-5_IPv4_only_parsed.txt)  

    [BIG-IP UCS](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve4-ltm-13-1-3-5.com-IPv4-only.ucs)  


<br/>  

## IPv6 Tunneled inside IPv4  

### IPv6 Tunneled inside IPv4 Lab Diagram  

![Lab Diagram](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/diagram/ipsec_lab_IPv6_inside_ipv4.png)  


###  This Configuration Supports IPv6 Tunneled inside IPv4 IPSEC  

1. BIG-IP ve2-ltm-13-1-3-5.com configuration  

    [BIG-IP SCF](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve2-ltm-13-1-3-5_IPv6_inside_IPv4_IPSEC_tunnel.txt.txt)  

    [BIG-IP Parsed SCF -- ready for cut and paste](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve2-ltm-13-1-3-5_IPv4_only_parsed.txt)  

    [BIG-IP UCS](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve2-ltm-13-1-3-5.com-ipv6-in-ipv4-tunnel.ucs)  

2. BIG-IP ve4-ltm-13-1-3-5.com configuration

    [BIG-IP SCF](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve4-ltm-13-1-3-5_IPv6_inside_IPv4_IPSEC_tunnel.txt.txt)  

    [BIG-IP Parsed SCF -- ready for cut and paste](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve4-ltm-13-1-3-5_IPv4_only_parsed.txt)  

    [BIG-IP UCS](https://github.com/grmarxer/Misc-Documentation/tree/master/IPSEC/configurations/ve4-ltm-13-1-3-5.com-ipv6-in-ipv4-ipsec-tunnel.ucs)  

<br/>  

### Troubleshooting Commands
```
tmsh modify net ipsec ike-daemon ikedaemon log-level info
tmsh modify net ipsec ike-daemon ikedaemon log-level debug2
```  

IKEv1 logs are in racoon.log  
IKEv2 logs are in ipsec.log
```
tail -f /var/log/racoon.log
```  
```
racoonctl -l show-sa isakmp
racoonctl -ll show-sa internal
```  
```
tmsh show net ipsec ipsec-sa
tmsh show net ipsec-stat
tmsh show net ipsec traffic-selector
```  
```
(IKEv1) tmsh delete net ipsec ipsec-sa
(IKEv2) tmsh delete net ipsec ike-sa
racoonctl flush-sa isakmp
```  

<br/>  

### Helpful Commands  

ip -6 route add fd00:172:16:10::/64 via fd00:172:16:110::1 dev ens192 metric 1  
ip -6 route  

curl -g http://[fd00:172:16:110::10]  
ping6 fd00:172:16:110::10  


<br/>  

[Good Reference - Configuring IPsec between a BIG-IP System and a Third-Party Device](https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-tmos-tunnels-ipsec-13-0-0/10.html)  

