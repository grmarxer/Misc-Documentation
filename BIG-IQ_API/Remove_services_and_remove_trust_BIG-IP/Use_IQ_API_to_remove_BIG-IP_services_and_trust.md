
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