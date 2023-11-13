
## How to form a BIG-IQ HA Pair when the MasterKey PassPhrase is unknown
<br/>  
Although it is impossible to recover the original Master Key, there is a workaround that will allow the customer to form a HA Pair by following this procedure (no downtime, no data loss):   

<br/>  

#### This procedure was tested and verified on BIG-IQ 7.1.0.2 and BIG-IQ 8.3.0  

<br/>  

1. In the active BigIQ console, save the script below into a new file (e.g. /config/MKSO_decrypt.sh):
    ```
    vi /config/MKSO_decrypt.sh
    ```

    ```
    #!/bin/sh

    F5MKU=$(f5mku -K | base64 -d | xxd -p)
    MKSO_ENC=$(tmsh list ltm profile server-ssl MasterKeyStorageObject.key | grep passphrase | cut -d '$' -f4)
    MKSO_DEC=$(echo ${MKSO_ENC} | base64 -d | openssl enc -d -aes-128-ecb -K ${F5MKU} | cut -c3-)
    echo $MKSO_DEC
    ```

2. Assign execution permissions with 'chmod +x /config/MKSO_decrypt.sh'. 
    ```
    chmod +x /config/MKSO_decrypt.sh
    ```

3. Run the script and save the output (should be a string similar to 'K65MqLxnAa7pTWLTr/j+PhwPBetNfoHoQYUY0xu0PHc=').  
    ```
    cd /config
    ./MKSO_decrypt.sh
    ```

4. In the secondary unit console, run 'clear-rest-storage -l -d' in order to return the unit to factory default.  
    ```
    clear-rest-storage -l -d
    ```

5. Wait until the secondary unit GUI is ready and it prompts for user credential login. The login credentials will be the default admin/admin.  

6.  Complete the initial wizard as desired, and enter any random Master Key when asked to. Be sure to add the VLAN and Self-IP addresses and choose the correct Discovery address.   Wait for the BIG-IQ services to come back online.  Once you are able to log into the GUI proceed to the next step.    

7. In the secondary console, run the following commands in order:  
    ```
    tmsh delete ltm profile server-ssl MasterKeyStorageObject.key
    tmsh create ltm profile server-ssl MasterKeyStorageObject.key passphrase [exact_string_obtained_in_step_3]
    tmsh save sys config
    tmsh restart sys service restjavad
    ```

8. Wait until the secondary unit GUI asks for credentials. At this point, the customer should be able to successfully add the secondary device from the primary GUI.  