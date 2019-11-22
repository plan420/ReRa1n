#!/bin/bash
# Over WiFi or USB
main_menu() {
    echo "[*] Which of the following option sets would you like to use: "
    echo "[*] Recovery options (1)"
    echo "[*] Tool options - W.I.P (2)"
    echo "[*] SSH Window (3)"
    echo "[*] Exit (X)"
    read -p "[*] Select an option using the shortened option names: " option
    if [ $option = 1 ]
    then
        recovery_options
    elif [ $option = 2 ]
    then
        tool_options
    elif [ $option = 3 ]
    then
        ssh_window
    elif [ $option = C ]
    then
        echo "[*] Developer: a_i_da_n"
        echo "[*] Usefull components libimobiledevice"
        echo "[*] Usefull components rcg4u"
        echo "[*] Original idea ConsoleLogLuke"
        main_menu
    elif [ $option = X ]
    then
        echo "[-] Exiting program"
        exit
    else
        echo "[-] Unexpected input exiting program"
        exit
    fi
}

recovery_options() {
    echo "[*] Which of the following options would you like to use: "
    echo  "[*] Respring - SpringBoard (1)"
    echo  "[*] Respring - backboardd (2)"
    echo  "[*] Reboot (3)"
    echo  "[*] Respring - Loop Fix (4)"
    echo "[*] Kill specified process (5)"
    echo "[*] Restore/Update to signed firmwares (6)"
    echo "[*] Back to main menu (<)"
    read -p "[*] Select an option using the shortened option names: " option
    if [ $option = "1" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -9 SpringBoard
        main_menu
    elif [ $option = "2" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -9 backboardd
        main_menu
    elif [ $option = "3" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport reboot
        main_menu
    elif [ $option = "4" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -8 SpringBoard
        main_menu
    elif [ $option = "5" ]
    then
        read -p "[*] Please enter the Proccess name to kill: " processname
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -9 $processname
        main_menu
    elif [ $option = "6" ]
    then
        idevicerestore -l
        main_menu
    elif [ $option = "<" ]
    then
        main_menu
    else
        echo "Unknown or Unrecognised command number"
    fi
}

tool_options() {
    echo "[*] Which of the following options would you like to use: "
    echo  "[*] UiCache (1)"
   # echo  "[*] iDevice Info V1.2 (2)"
    echo "[*] Install Packages - bundle indetifier required (3)"
    echo "[*] Remove Packages - bundle identifier required (4)"
    echo "[*] Backup entire drive (This takes absoutely forever please do not use, 5)"
    echo "[*] "
    echo "[*] Back to main menu (<)"
    read -p "[*] Select and option using the shortened option names: " option
    if [ $option = 3 ]
    then
        read -p "[*] Enter the bundle identifier of the package: " idevicebundleidentifier
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport apt-get install $idevicebundleidentifier
        main_menu
    elif [ $option = 4 ]
    then
        read -p "[*] Enter the bundle identifier of the package: " idevicebundleidentifier
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport apt-get remove $idevicebundleidentifier
        main_menu
    elif [ $option = "1" ]
    then
        sshpass -p$idevicepassword ssh mobile@$ideviceip -p $ideviceport uicache
        main_menu
    elif [ $option = "2" ]
    then
        ideviceinfo > ideviceinfo.txt
        grep ActivationState: ideviceinfo.txt
        grep BasebandVersion: ideviceinfo.txt
        grep BluetoothAddress: ideviceinfo.txt
        grep BuildVersion: ideviceinfo.txt
        grep CPUArchitecture: ideviceinfo.txt
        grep DeviceClass: ideviceinfo.txt
        grep DeviceColor: ideviceinfo.txt
        grep EthernetAddress: ideviceinfo.txt
        grep FirmwareVersion: ideviceinfo.txt
        grep HardwareModel: ideviceinfo.txt
        grep HardwarePlatform: ideviceinfo.txt
        grep PasswordProtected: ideviceinfo.txt
        grep ProductType: ideviceinfo.txt
        grep ProductVersion: ideviceinfo.txt
        grep -w SerialNumber: ideviceinfo.txt
        grep WiFiAddress: ideviceinfo.txt
        main_menu
    elif [ $option = "5" ]
    then
        scp -p -R 2222 root$ideviceip:/* .
    elif [ $option = "6" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport psswd 
    elif [ $option = "<" ]
    then
        main_menu
    else
        echo "[-] Unexpected option selected"
        exit
    fi
}

ssh_window() {
    echo "[*] Connecting to iDevice"
    sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport
    echo "[*] Sucessfully exited SSH window"
    main_menu
}

echo [*] Welcome to ReRa1n
echo "[*] Checking for dependencies"
read -p "[*] Do you want to install dependencies manually or have the script do it for you? (M/A) " autog
if [ $autog = M ]
then 
   echo "[*] Manual installation guide available on the github repository under MANUAL.md"
else
    if [ ! -e rerain-dep ]
    then
        # Telling the user dependencies have not been found
        echo "[-] Dependencies not found"
        # Telling the user we are installing dependencies
        echo "[*] Installing dependencies"
        # Telling the user we are checking package manager
        echo "[*] Checking Package Manager"
        # Checking package manager
        if [ $(which apt-get) ];
        then
            sh install.sh
        else
            echo "[-] Package manager not supported please go to the github page and open an issue adding you current package manager"
            exit
        fi
        exit
    fi
fi
if [ -e rerain-dep ]
then
    echo "[*] Dependencies found!"
fi
read -p "[*] SSH over WiFi, USB or NONE (CaSeSeNsItIvE): " wifiorusb
echo [*] You chose $wifiorusb.
if [ $wifiorusb = "WiFi" ]
then
    # SSH over WiFi is selected
    echo [*] WiFi selected.
    # Setting Global Variables
    ideviceport=22
    # Getting IP & Root Password
    read -p "[*] Enter the IP address of your iDevice: " ideviceip
    read -p "[*] Enter the root password of your iDevice (Default is alpine, make sure to change): " idevicepassword
    # SSHing into iDevice
    ssh root@$ideviceip exit
    sshpass -p$idevicepassword ssh root@$ideviceip cd /
    echo [*] Connected to iDevice
    # Declaring recovery and tool functions for WiFi
    main_menu
elif [ $wifiorusb = "USB" ]
then
    echo [*] USB selected.
    ideviceip=localhost
    ideviceport=2222
    cd rerain-dep
    echo "[*] Open a second terminal window and enter: cd /usr/bin sudo fordward.sh "
    read -p "[*] Press enter to continue:"
    read -p "[*] Enter the root password of your iDevice (Default is alpine, make sure to change this): " idevicepassword
    ssh root@localhost -p 2222 exit
    sshpass -p$idevicepassword ssh root@localhost -p 2222 cd /
    echo "[*] Connected to iDevice"
    main_menu
elif [ $wifiorusb = "NONE" ]
then
    echo "[-] This function is W.I.P"
    echo "[*] Please select an option: "
    echo "[*] Restore/Update - (1)"
    echo "[*] Reboot - [DFU/RESTORE] - (2)"
  #  echo "[*] iDeviceInfo V1.1 - Experimental (3)"
    read -p "[*] Select an option using the shortened option names" option
    if [ $option = "1" ]
    then
        idevicerestore -l
        exit
    elif [ $option = "2" ]
    then
        irecovery -c reboot
        echo "[*] iDevice rebooting"
        exit
    elif [ $option = 3 ]
    then
        ideviceinfo > ideviceinfo.txt
        grep ActivationState: ideviceinfo.txt
        grep BasebandVersion: ideviceinfo.txt
        grep BluetoothAddress: ideviceinfo.txt
        grep BuildVersion: ideviceinfo.txt
        grep CPUArchitecture: ideviceinfo.txt
        grep DeviceClass: ideviceinfo.txt
        grep DeviceColor: ideviceinfo.txt
        grep EthernetAddress: ideviceinfo.txt
        grep FirmwareVersion: ideviceinfo.txt
        grep HardwareModel: ideviceinfo.txt
        grep HardwarePlatform: ideviceinfo.txt
        grep PasswordProtected: ideviceinfo.txt
        grep ProductType: ideviceinfo.txt
        grep ProductVersion: ideviceinfo.txt
        grep -w SerialNumber: ideviceinfo.txt
        grep WiFiAddress: ideviceinfo.txt
    else
        exit
    fi
else
    echo [-] Unknown or Unavailable selected.
    exit
fi
