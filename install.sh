#!/bin/bash
echo " ONLY FOR EDUCATIONAL PURPOSE "
case `dpkg --print-architecture` in
aarch64)
echo -e "(error) The script only supports AMD 64 architecture Debian and derivatives systems [✗]"
exit
;;
arm)
echo -e "(error) The script only supports AMD 64 architecture Debian and derivatives systems [✗]"
exit
;;
armhf)
echo -e "(error) The script only supports AMD 64 architecture Debian and derivatives systems [✗]"
exit
;;

i*86)
echo -e "(error) The script only supports AMD 64 architecture Debian and derivatives systems [✗]"
exit
;;
x86_64)
echo -e "(error) The script only supports AMD 64 architecture Debian and derivatives systems [✗]"
exit
;;
esac

if [[ $EUID -ne 0 ]]; then	
	echo "----------------------------------------------------------------------------------------------------------------"
	echo " 			(✗) You are not a root user, to run the tool you have to run it as root (✗)  		      "				  
	echo "----------------------------------------------------------------------------------------------------------------"		
        	exit 1
fi

apt-get update -y
clear
if which airodump-ng >/dev/null; then
         echo -e "(AIRODUMP-NG) .................................................. Installed [✓]"
else
	 echo -e "(AIRODUMP-NG) Not installed [✗]"
	apt-get install aircrack-ng -y
fi

if which mdk3 >/dev/null; then
         echo -e "(MDK3) .................................................. Installed [✓]"
else
	 echo -e "(MDK3) Not installed [✗]"
	 apt-get install mdk3 -y
fi

if which toilet >/dev/null; then
         echo -e "(Toilet) .................................................. Installed [✓]"
else
	 echo -e "(Toilet) Not installed [✗]"
	 apt-get install toilet -y
fi

if which macchanger >/dev/null; then
         echo -e "(macchanger) .................................................. Installed [✓]"
else
	 echo -e "(macchanger) Not installed [✗]"
	 apt-get install macchanger -y
fi

if which ruby >/dev/null; then
         echo -e "(ruby) ......................................................... Installed [✓]"
	       gem install lolcat
else
	 echo -e "(macchanger) Not installed [✗]"
	 apt-get install ruby -y
	 gem install lolcat
fi

clear
chmod +x routerkill.sh
mkdir handshake

echo "Select an option:"
echo "1. Python script"
echo "2. Bash script"
read -p "Option: " option

if [[ $option -eq 1 ]]; then
    sudo python3 killrouter.py
elif [[ $option -eq 2 ]]; then
    sudo bash killrouter.sh
else
    echo "Invalid option. Select 1 or 2."
fi
