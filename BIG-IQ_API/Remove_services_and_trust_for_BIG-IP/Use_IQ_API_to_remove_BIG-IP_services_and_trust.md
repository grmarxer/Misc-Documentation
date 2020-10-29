# Removing BIG-IP Services and Device Trust from BIG-IQ using the BIG-IQ API

<br/>  

## Summary  

In this procedure we will provide the user with the steps to remove a BIG-IP from the BIG-IQ Device list using the BIG-IQ API.  This requires removing the BIG-IP services as well as removing the BIG-IP itself.  This procedure provides the steps for removing a single device, however, a sophisticated user could take the information here and create a script to remove several devices.  

__NOTE:__  This procedure uses basic-auth and not a token for authenticating to the BIG-IQ

<br/>  

## Kubernetes Ingress Overview   




https://support.f5.com/csp/article/K43725273


https://support.f5.com/csp/article/K04452074

set-basic-auth
set-basic-auth on



```
curl -ks -u admin:password -H "Content-Type: application/json" https://192.168.2.40/mgmt/cm/system/machineid-resolver | jq '.items[] | {uuid,hostname,version,product,managementAddress,selfLink}'
```

```
[root@ve1-IQ-7-1-0-1:Active:Standalone] ~ # curl -ks -u admin:password -H "Content-Type: application/json" https://192.168.2.40/mgmt/cm/system/machineid-resolver | jq '.items[] | {uuid,hostname,version,product,managementAddress,selfLink}'
{
  "uuid": "3a897937-4b83-4456-859d-dc1d47fa769d",
  "hostname": "VE4-13-1-0-8.com",
  "version": "13.1.0.8",
  "product": "BIG-IP",
  "managementAddress": "192.168.2.35",
  "selfLink": "https://localhost/mgmt/cm/system/machineid-resolver/3a897937-4b83-4456-859d-dc1d47fa769d"
}
{
  "uuid": "91d584ce-ce92-44ae-9e47-4ca48822186e",
  "hostname": "ve1-IQ-7-1-0-1.com",
  "version": "7.1.0.1",
  "product": "BIG-IQ",
  "managementAddress": "192.168.2.40",
  "selfLink": "https://localhost/mgmt/cm/system/machineid-resolver/91d584ce-ce92-44ae-9e47-4ca48822186e"
}
[root@ve1-IQ-7-1-0-1:Active:Standalone] ~ #
```

```
curl -k -u admin:password -X POST \
  https://192.168.2.40/mgmt/cm/global/tasks/device-remove-mgmt-authority \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
    "deviceReference": {
        "link": "https://localhost/mgmt/cm/system/machineid-resolver/3a897937-4b83-4456-859d-dc1d47fa769d"
    },
    "moduleList": [
        {
            "module": "adc_core"
        },
        {
            "module": "fps"
        },
        {
            "module": "access"
        },
        {
            "module": "dns"
        },
        {
            "module": "security_shared"
        },
        {
            "module": "firewall"
        },
        {
            "module": "asm"
        }
    ]
}'
```  

```
curl -k -u admin:peachman -X POST \
  https://192.168.2.40/mgmt/cm/global/tasks/device-remove-trust \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
     "deviceReference": {
          "link": "https://localhost/mgmt/cm/system/machineid-resolver/3a897937-4b83-4456-859d-dc1d47fa769d"
      }
}
'
```