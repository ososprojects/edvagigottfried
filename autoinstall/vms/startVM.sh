#!/bin/bash

# Startscript for Virtual Machines
# Idee from VlizedLab http://www.vlizedlab.at/
# Changes by Reinhard Fink
# call Script with Parameters
# 1:	Name of Virtual Machine Harddisk File without Ending .vdi
#		Standard: Windows
# 2:	OS - Type: Windows7, OpenSUSE, Ubuntu, ...
#		Standard: Windows7
# 3:	USB: usbon/usboff
#		Standard usbon
#
# Examples: 
#	startVM  			starts Virtualmachine Windows.vdi with OS-Type Windows7 an USB on
#	startVM	ubu Ubuntu usboff	starts Virtualmachine ubu.vdi with OS-Type Ubuntu an USB off
#	startVM	ubu Ubuntu 		starts Virtualmachine ubu.vdi with OS-Type Ubuntu an USB on
#
#
#
# Create Variables and Directories ######################################################
#
echo "Set Variables"
if [ -z $1 ];
then
	MACHINE=Windows
else
	MACHINE=$1
fi
echo "Machinename: " $MACHINE

if [ -z $2 ];
then
	OS_TYPE=Windows7
else
	OS_TYPE=$2
fi
echo "OS Type: " $OS_TYPE

if [ ! -z $3 ] && [ $3 = "usboff" ];
then
	USB=usboff
else
	USB=usbon
fi
echo "USB: " $USB

MACHINE_STORAGE_DIR=/opt/vms
echo "Readonly Storage Directory for VMs: " $MACHINE_STORAGE_DIR

if [ ! -f $MACHINE_STORAGE_DIR/$MACHINE.vdi ];
then
	echo "File "$MACHINE_STORAGE_DIR/$MACHINE" does not exist"
	echo "--- AUTOMATIK UPDATE TRY LATER! ---"
	echo "--- OR WRONG FILENAME! ---"
	exit
fi

MACHINE_WORK_DIR=/tmp/${USER}_vms
echo "Working Directory for Current Running VM: " $MACHINE_WORK_DIR

# Set Ramsize for Host
HOST_RAM=$((1024 + 0))
# Get available Ramsize from Host
VM_RAM=$(cat /proc/meminfo | grep MemTotal: | awk -F' ' '{ print $2 }' )
# Ramsize im MB
VM_RAM=$(($VM_RAM / 1024))
# Calculate VM_RAM
VM_RAM=$(($VM_RAM - $HOST_RAM))
#VM_RAM=1024
echo "Ram Size for VM: " $VM_RAM


echo "Manage Directorys"
echo "Save original .VirtualBox Directory, if exists and .VirtualBox.$USER does not exist"
if [ -d $HOME/.config/VirtualBox ] && [ ! -d $HOME/.VirtualBox.$USER ];
then
	mv $HOME/.config/VirtualBox $HOME/.VirtualBox.$USER
fi

echo "Create Machine Work Directory"
if [ -d $MACHINE_WORK_DIR ];
then
	rm -R $MACHINE_WORK_DIR
fi
mkdir -p $MACHINE_WORK_DIR


SCHUELER_DIR="/home/shares/schueler"
echo "Directory for: " $SCHUELER_DIR

LEHRMATERIAL_DIR="/home/shares/lehrmaterial"
echo "Directory for: " $LEHRMATERIAL_DIR

PROGRAMMES_DIR="/home/shares/programmes"
echo "Directory for: " $PROGRAMMES_DIR

CONFIG_WINONTOP_DIR=$MACHINE_STORAGE_DIR"/configwinontop"
echo "Config Directory for WinOnTop: " $CONFIG_WINONTOP_DIR



# Create Virtual Machine ################################################################
#
echo "Create Virtual Machine"
VBoxManage --nologo createvm --name $MACHINE --register --basefolder $MACHINE_WORK_DIR
# OS
VBoxManage --nologo modifyvm $MACHINE 	--ostype $OS_TYPE
# CPU + GPU
VBoxManage --nologo modifyvm $MACHINE 	--memory $VM_RAM
VBoxManage --nologo modifyvm $MACHINE 	--vram 128
VBoxManage --nologo modifyvm $MACHINE 	--acpi on
# ioacoi off IMPORTANT: otherwise Windows wants to reinstall CPU - Driver
VBoxManage --nologo modifyvm $MACHINE 	--ioapic off
VBoxManage --nologo modifyvm $MACHINE 	--hwvirtex on
VBoxManage --nologo modifyvm $MACHINE 	--pae off
# BIOS
VBoxManage --nologo modifyvm $MACHINE 	--bioslogofadein off
VBoxManage --nologo modifyvm $MACHINE 	--bioslogofadeout off
VBoxManage --nologo modifyvm $MACHINE 	--bioslogodisplaytime 1
# NetworkAdapter
VBoxManage --nologo modifyvm $MACHINE 	--nictype1 82540EM
VBoxManage --nologo modifyvm $MACHINE 	--nic1 nat
#VBoxManage --nologo modifyvm $MACHINE 	--macaddress1 0800276D37F9
# Set Address space for internal NetworkAdapter 
VBoxManage --nologo modifyvm $MACHINE   --natnet1 10.250.250.0/24
# AudioAdapter
VBoxManage --nologo modifyvm $MACHINE 	--audio alsa --audiocontroller hda

# USB solved with SharedFolder
#VBoxManage --nologo modifyvm $MACHINE 	--usb on
#VBoxManage --nologo modifyvm $MACHINE 	--usbehci on

# --boot<1-4> none|floppy|dvd|disk|net
VBoxManage --nologo modifyvm $MACHINE 	--boot1 disk

echo "Create Harddisk Controller for Virtual Machine"
# IDE
VBoxManage --nologo storagectl $MACHINE --name IDE-Controller-$MACHINE --add ide --controller PIIX4 --hostiocache on
# SATA
VBoxManage --nologo storagectl $MACHINE --name SATA-Controller-$MACHINE --add sata --controller IntelAHCI --portcount 1 --hostiocache off

echo "Link Machine VDI from Storage Directory to Work Directory"
ln -s $MACHINE_STORAGE_DIR/$MACHINE.vdi $MACHINE_WORK_DIR/$MACHINE/$MACHINE.vdi

echo "Attach Harddisk to Virtual Machine"
VBoxManage --nologo storageattach $MACHINE --storagectl SATA-Controller-$MACHINE --port 0 --device 0 --type hdd --medium $MACHINE_WORK_DIR/$MACHINE/$MACHINE.vdi --mtype immutable


echo "Set Display Settings/Supress Notifications"
VBoxManage setextradata global GUI/SuppressMessages confirmGoingFullscreen,confirmInputCapture,remindAboutAutoCapture,remindAboutWrongColorDepth,remindAboutMouseIntegration

VBoxManage setextradata $MACHINE GUI/Fullscreen on
VBoxManage setextradata $MACHINE GUI/ShowMiniToolBar no


# Create Shared Folder
# Folders, witch are mounted inside Virtual Windows every time, via script mountshares.cmd in .../Autostart
echo "Createing shared Folders"
if [ -d $SCHUELER_DIR ];
then
	echo "Create shared Folder for Directory: "$SCHUELER_DIR
	VBoxManage sharedfolder add $MACHINE --name schueler --hostpath $SCHUELER_DIR
fi
if [ -d $LEHRMATERIAL_DIR ];
then
	echo "Create shared Folder for Directory: "$LEHRMATERIAL_DIR
	VBoxManage sharedfolder add $MACHINE --name lehrmaterial --hostpath $LEHRMATERIAL_DIR
fi
if [ -d $PROGRAMMES_DIR ];
then
	echo "Create shared Folder for Directory: "$PROGRAMMES_DIR
	VBoxManage sharedfolder add $MACHINE --name programmes --hostpath $PROGRAMMES_DIR
fi

if [ -d $CONFIG_WINONTOP_DIR ];
then
	echo "Create shared Folder Configuration Directory: "$CONFIG_WINONTOP_DIR
	VBoxManage --nologo sharedfolder add $MACHINE --name configwinontop --hostpath $CONFIG_WINONTOP_DIR
fi

if [ $USB = "usbon" ];
then
	echo "Create shared Folder for USB"
	VBoxManage sharedfolder add $MACHINE --name USB-Storage --hostpath /media --automount
fi

echo "Create shared Folder for Home Directory: "$HOME
VBoxManage --nologo sharedfolder add $MACHINE --name myHome --hostpath $HOME


echo "Start Virtual Machine"
# Starts VM and return to this Script, when VM shuts down
#VBoxManage startvm $MACHINE
VirtualBox --startvm $MACHINE --fullscreen

echo "Restore all Virtualbox Config - Directories"
echo "Wait for 2 seconds to shutdown virtual machine"
sleep 2
rm -R $HOME/.config/VirtualBox
rm -R $MACHINE_WORK_DIR
echo "Restore original .config/VirtualBox Directory if exists."
if [ -d $HOME/.VirtualBox.$USER ];
then
	mv $HOME/.VirtualBox.$USER $HOME/.config/VirtualBox
fi
