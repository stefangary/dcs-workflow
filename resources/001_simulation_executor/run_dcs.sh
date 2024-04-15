# run in bat file to get correct exit code from the software
#echo set DCS2FLMD_LICENSE_FILE="$DCS2FLMD_LICENSE_FILE" > run.bat

# Load 3dcs environment
if ! [ -z "${dcs_load}" ]; then
    eval "${dcs_load}"
fi

# Run 3dcs
SECONDS=0
eval "${dcs_run}"  macroScript.txt
# Results is own by root
sudo chmod 777 Results/ -R
echo ${SECONDS} > Results/dcs-runtime_${case_index}.txt

