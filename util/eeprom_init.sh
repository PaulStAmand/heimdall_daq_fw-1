#!/bin/bash
echo "Initialzing EEPROM conectent and setting serial numbers"
device_count=$(lsusb | grep "Realtek" | wc -l)
echo "Found $device_count receivers"
while true; do
    read -p "Do you wish to overwrite the current EEPROM content?" yn
    case $yn in
        [Yy]* )echo "yes"; break;;
        [Nn]* )echo "no"; exit;;
        *) echo "Please answer yes or no"
    esac
done
device_cntr=$((device_count-1))
for i in $(eval echo "{0..$device_cntr}")
do
    read -p "Please turn off all channels excepting channel number:$i and press enter" dummy
    # Check the number of online devices
    curr_device_count=$(lsusb | grep "Realtek" | wc -l)
    if test $curr_device_count -ne 1
    then
        echo "More than one online device has been detected, exiting"
        #exit
    fi
    serial=$((i+1000))
    rtl_eeprom -d 0 -g realtek_oem
    rtl_eeprom -d 0 -s $serial -m RTL-SDR -p KerberosSDR
done
echo "EEPROM writing script finished. Plese perform a full power cycle."
