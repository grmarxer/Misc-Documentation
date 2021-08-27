#!/bin/bash
##########################################################################################
##                                                                                      ##
## Script to use BIG-IQ API to remove services from discovered BIG-IP's in bulk --      ##
##                                                                                      ##
## The script executes one API call at a time -- reiterating through a list of          ##
## BIG-IP machine ID's that are populated into an array.  The script attempts each API  ##
## call based on a set timer, this is because BIG-IQ can only process one API call      ##
## at a time.  If the script issues a API call to BIG-IQ and BIG-IQ is busy             ##
## the script will recognize the error and retry that API call again                    ##
## after a set number of seconds.                                                       ## 
##                                                                                      ##
## Created by Gregg Marxer (g.marxer@f5.com)                                            ##
## Date: 08262021 Revision 1                                                            ##
##                                                                                      ## 
##########################################################################################

#################################################################################
###                                                                           ###
###  prerequisites to using this script                                       ###
###                                                                           ###
#################################################################################
#
# Enable basic authentication on BIG-IQ so username and password can be used in API call
# 	- Turn on basic auth from BIG-IQ command line -- set-basic-auth on
# 	- Turn off basic auth after procedure is complete -- set-basic-auth off
# 	- To view current basic auth setting -- set-basic-auth
#
# Make script executable ex. chmod 777 <scriptName>
# Create text file with BIG-IP Machine ID's for which BIG-IQ services will be removed and upload it to the device that this 
# script will be executed on.

#################################################################################
###                                                                           ###
###  This is the only section of the script to be modified by user            ###
###                                                                           ###
#################################################################################
username=admin                  # replace admin with your BIG-IQ username
password=default                # replace default with your BIG-IQ password
mgmtIP="[fd00:172:aa:bb::10]"   # Enter your BIG-IQ mgmt IP address, if using IPV6 be sure to include brackets inside the quotes.
pathToFile="/var/tmp/machineId_file.txt"  # replace with path to the Machine ID text file you created




#################################################################################
#################################################################################
#################################################################################
###                                                                           ###
###  User not to modify anything beyond this point                            ###
###                                                                           ###
#################################################################################
#################################################################################
#################################################################################
#
## Setting the sleep timer and retry timer variables in seconds
sleepTimer=7
retryTimer=10


## This step creates the array with the BIG-IP Machine ID's for which the services will be removed on BIG-IQ.  Enter each machine ID on a new line.
## if you use this approach you must comment out the readarray file approach below  
#uuidArray=(
#326d3709-fdf7-498f-8d00-b52c7bb192d9
#3ac4ad82-add1-420f-b6e9-301722b6e7c4
#)


## Reading in a text file to create the uuidArray array with the BIG-IP Machine ID's to have the services removed from BIG-IQ 
## Important ## Make sure there are no empty lines in the text file.  One Machine ID per line only
readarray -t uuidArray < $pathToFile


## This the function to execute API Curl command with the username, password, BIG-IQ mgmt IP and BIG-IP Machine ID substituted via variables, the
## output of the function will be store in the statusCode variable so we can run and if/then against it to makse sure the HTTP Post did not fail.
function curlCommand {
statusCode=$(curl -k  -u $username:$password -X POST \
https://$mgmtIP/mgmt/cm/global/tasks/device-remove-mgmt-authority \
-H 'Content-Type: application/json' \
-H 'cache-control: no-cache' \
-d '{
    "deviceReference": {
        "link": "https://localhost/mgmt/cm/system/machineid-resolver/'$uuid'"
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
}')
## If BIG-IQ is busy and cannot accept the API call it will be caught here and attempted again based on the retryTimer value
if [[ $statusCode == *'"code":400,'* ]]
then
    clear; echo; echo "BIG-IQ is busy will retry BIG-IP Machine ID $uuid in $retryTimer seconds"
    sleep $retryTimer
    echo
    curlCommand
fi
}


## This is the for loop that will reiterate through the array and execute the function call for each Machine ID
for uuid in "${uuidArray[@]}"
do
  curlCommand
  sleep $sleepTimer
done


## Message indicating end of script
clear; echo; echo
echo "This script is complete.  All BIG-IQ services for the BIG-IP Machine ID's entered should now be removed."; echo; echo
