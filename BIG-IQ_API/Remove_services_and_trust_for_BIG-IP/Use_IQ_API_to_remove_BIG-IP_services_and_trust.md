# Removing BIG-IP Services and Device Trust from BIG-IQ using the BIG-IQ 7.1.0.1 API

<br/>  

## Summary  

In this procedure we will provide the user with the steps to remove a BIG-IP from the BIG-IQ Device list using the BIG-IQ API.  This requires removing the BIG-IP services as well as removing the BIG-IP itself.  This procedure provides the steps for removing a single device, however, a sophisticated user could take the information here and create a script to remove several devices.  


<br/>  

## Authenticating to BIG-IQ when using the API  

Beginning in BIG-IQ Centralized Management 5.1.0, the system has HTTP basic authentication disabled, by default.  With this change, the BIG-IQ system has, by default, disabled basic authentication for HTTP/HTTPS requests to the REST framework. This is a security enhancement.  

Reference Links: [K43725273: The BIG-IQ system has HTTP basic authentication disabled by default](https://support.f5.com/csp/article/K43725273) and [K04452074: Overview of using the BIG-IQ system authentication token](https://support.f5.com/csp/article/K04452074)  


__NOTE:__  In this procedure we will use basic-auth and not a token for authenticating to the BIG-IQ.  The steps to enable basic authentication are included below.  

<br/>  

## Procedure  

1.  Enable basic authentication on BIG-IQ from the command line.  This will allow you to use a username and password to make your API calls to BIG-IQ  

    - ssh to the BIG-IQ  

        ```
        [root@ve1-IQ-7-1-0-1:Active:Standalone] tmp # set-basic-auth
        Basic auth is disabled.
        ```  

        ```
        [root@ve1-IQ-7-1-0-1:Active:Standalone] tmp # set-basic-auth on
        Basic auth is enabled.
        ```  
        ```
        [root@ve1-IQ-7-1-0-1:Active:Standalone] tmp # set-basic-auth
        Basic auth is enabled.
        ```

    - Now you can use basic authentication to make API calls to the BIG-IQ

<br/>  

2.  Query the BIG-IQ using the following API to get a list of the discovered BIG-IP devices and associated UUID's  

    Enter the contents for the following specific to your enviroment for the API call below  
    - username = BIG-IQ admin account  
    - password = BIG-IQ Admin account password
    - BIG-IQ mgmt address = BIG-IQ mgmt IP address
    <br/>  

    ```
    curl -ks -u username:password -H "Content-Type: application/json" https://BIG-IQ mgmt address/mgmt/cm/system/machineid-resolver | jq '.items[] | {uuid,hostname,version,product,managementAddress,selfLink}'
    ```
    <br/>  

    ```
    [root@ve1-IQ-7-1-0-1:Active:Standalone] ~ # curl -ks -u admin:adminPassword -H "Content-Type: application/json" https://192.168.2.40/mgmt/cm/system/machineid-resolver | jq '.items[] | {uuid,hostname,version,product,managementAddress,selfLink}'
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
    <br/>  

    ![BIG-IQ Device List Image](https://github.com/grmarxer/Misc-Documentation/blob/master/BIG-IQ_API/Remove_services_and_trust_for_BIG-IP/illustrations/BIG-IP_device_to_be_removed.png)  


<br/>  

3.   In this step we are going to remove all of the services associated with BIG-IP `"hostname": "VE4-13-1-0-8.com"` using its UUID `3a897937-4b83-4456-859d-dc1d47fa769d`  

        If interested, I have written a script that will remove services for multiple BIG-IP's in bulk based on either a text file or by placing the UUID's directly in the array itself.  

        - [Script can be found here](https://github.com/grmarxer/Misc-Documentation/blob/master/BIG-IQ_API/Remove_services_and_trust_for_BIG-IP/scripts/Remove_services_in_bulk_from_IQ_script.sh)  

        - [Example of text file to use with the script can be found here](https://github.com/grmarxer/Misc-Documentation/blob/master/BIG-IQ_API/Remove_services_and_trust_for_BIG-IP/scripts/machineId_file.txt)  


        <br/>  
        <br/>  

        __Note:__ Be sure to substitute the credentials outlined above in the command below  


        ```
        curl -k -u admin:adminPassword -X POST \
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
<br/>  

4. In this step we will remove the BIG-IP from the BIG-IQ device list using its UUID `3a897937-4b83-4456-859d-dc1d47fa769d`  

    __Note:__ Be sure to substitute the credentials outlined above in the command below  

    <br/>  

    ```
    curl -k -u admin:adminPassword -X POST \
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
<br/>  

5. The BIG-IP above should now be removed from the BIG-IQ devices tab  

    __Note:__  It will take the BIG-IQ GUI approximately 10 seconds to catch up  
    <br/>  

    ![After BIG-IP Removed Image](https://github.com/grmarxer/Misc-Documentation/blob/master/BIG-IQ_API/Remove_services_and_trust_for_BIG-IP/illustrations/after_device_removed.png)  




