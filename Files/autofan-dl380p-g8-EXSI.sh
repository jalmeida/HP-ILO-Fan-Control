#!/bin/bash
#
# crontab -l > mycron
# echo "#" >> mycron
# echo "# At every 2nd minute" >> mycron
# echo "*/1 * * * * /bin/bash /autofan.sh >> /tmp/cron.log" >> mycron
# crontab mycron
# rm mycron
# chmod +x /autofan.sh
#

PASSWORD="YOUR_ILO_PASSWORD"
USERNAME="YOUR_ILO_USER"
ILOIP="YOUR_ILO_IP"

FILE="/usr/bin/sshpass"
if [ -f "$FILE" ]; then
    echo "sshpass already loaded."

else
    esxcli network firewall ruleset set -e true -r httpClient
    pwdlocation=$(pwd)
    cd /tmp
    wget https://github.com/jalmeida/HP-ILO-Fan-Control/raw/refs/heads/main/Files/sshpass --no-check-certificate
    mv sshpass /usr/bin/sshpass
    chmod +x /usr/bin/sshpass
    cd ${pwdlocation}
    echo "sshpass loaded."

fi

esxcli network firewall ruleset set -e true -r sshClient

#T1="$(sensors -Aj coretemp-isa-0000 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"
#T2="$(sensors -Aj coretemp-isa-0001 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"

sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP show /system1/sensor2 > temp.txt
T1CLEAN=$(grep -Ihr "CurrentReading" temp.txt)
T1=$(echo "${T1CLEAN/    CurrentReading=/}" | xargs)
rm -rf temp.txt

sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP show /system1/sensor3 > temp.txt
T2CLEAN=$(grep -Ihr "CurrentReading" temp.txt)
T2=$(echo "${T2CLEAN/    CurrentReading=/}" | xargs)
rm -rf temp.txt

sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP show /system1/sensor25 > temp.txt
T2CLEAN=$(grep -Ihr "CurrentReading" temp.txt)
RAID=$(echo "${T2CLEAN/    CurrentReading=/}" | xargs)
rm -rf temp.txt

T1=${T1//$'\n'/}
T2=${T2//$'\n'/}
RAID=${RAID//$'\n'/}

T1=${T1%$'\n'}
T2=${T2%$'\n'}
RAID=${RAID%$'\n'}

echo "CPU 1 Temp $T1 C"

if [[ "${T1}" -gt 67 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 255'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 255'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 255'

elif [[ "${T1}" -gt 58 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 39'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 39'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 39'

elif [[ "${T1}" -gt 54 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 38'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 38'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 38'

elif [[ "${T1}" -gt 52 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 34'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 34'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 34'

elif [[ "${T1}" -gt 50 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 30'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 30'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 30'

else
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 20'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 20'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 20'

fi

echo "CPU 2 Temp $T2 C"

if [[ "${T2}" -gt 67 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 255'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 255'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 255'

elif [[ "${T2}" -gt 58 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 39'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 39'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 39'

elif [[ "${T2}" -gt 54 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 38'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 38'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 38'

elif [[ "${T2}" -gt 52 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 34'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 34'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 34'

elif [[ "${T2}" -gt 50 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 30'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 30'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 30'

else
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 20'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 20'
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 20'

fi

echo "RAID Temp $RAID C"
if [[ "${RAID}" -gt 97 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 255'

elif [[ "${RAID}" -gt 95 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 90'

elif [[ "${RAID}" -gt 94 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 85'

elif [[ "${RAID}" -gt 93 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 60'

elif [[ "${RAID}" -gt 92 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 55'

elif [[ "${RAID}" -gt 91 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 50'

elif [[ "${RAID}" -gt 90 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 45'

elif [[ "${RAID}" -gt 89 ]]; then
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 40'

else
    sshpass -p $PASSWORD ssh -oHostKeyAlgorithms=+ssh-dss -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 35'

fi
