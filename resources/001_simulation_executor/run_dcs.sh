# run in bat file to get correct exit code from the software
#echo set DCS2FLMD_LICENSE_FILE="$DCS2FLMD_LICENSE_FILE" > run.bat

# Load 3dcs environment
if ! [ -z "${dcs_load}" ]; then
    eval "${dcs_load}"
fi

# Create metering script
cat >> metering.sh <<HERE
#!/bin/bash
while true; do
    ssh ${resource_ssh_usercontainer_options} usercontainer ssh ${metering_user}@${metering_ip} "date" >> /home/${metering_user}/.3dcs/usage-pending/$(hostname)-${job_number}
    sleep 60
done
HERE

chmod + metering.sh
./metering.sh &
metering_pid=$!

# Run 3dcs
SECONDS=0
eval "${dcs_run}"  macroScript.txt
kill ${metering_pid}

# Results is own by root
sudo chmod 777 Results/ -R
echo ${SECONDS} > Results/dcs-runtime_${case_index}.txt

