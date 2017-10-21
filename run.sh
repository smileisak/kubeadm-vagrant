#!/usr/bin/env sh
set -e

# Regular Colors
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[1;33m'
NC='\033[0m' # No Color


echo ${Red}'[*] Starting Centos 7.1 VMs!'${NC}

#set -v
###
# This script mainly removes NAT from adaptor 1, and replace it with bridged for all machines
# If required, change the interface in the line below or pass as a parameter: --bridged_adapter
HOST_BRIDGED_INTERFACE=`ip route | grep default | head -1 | cut -d" " -f5`
# This is the same interface you may want to set in the Vagrantfile (or prompting you for)
# This entire script works only with virtualbox provider
###

# Optionally, when started with params like reset or init, it also does vagrant up, etc.
while [ $# -gt 0 ]; do
 case $1 in
  --full) 
    vagrant destroy -f || true
    vagrant up
    shift
  ;;
  --bridged_adapter)
    HOST_BRIDGED_INTERFACE=$2
  shift
  shift
  ;;
 esac
done

# How to start
VAGRANT_LOG=debug # debug,info,warn,error
#vagrant up

###  Stop all machines for reconfiguration:
for runningVagrM in $(vagrant status | grep 'running (virtualbox)' | cut -d" " -f1); do
  vagrant halt $runningVagrM
done


### Get list of all already powered off machines:
filter_machines_offvagm=$(vagrant status | grep 'poweroff (virtualbox)' | cut -d" " -f1)

if [ "${filter_machines_offvagm}x" = "x" ]; then
 echo "There is no machine to manage, exit now"
 exit 1 # && error_now
fi

### Get list of machines created for local Vagrantfile in the current directory
filter_machines_local_directory=$(basename `pwd`)  # note: cannot run it from /

###

echo ${Green}"[-] Reconfigure the interfaces, disabling the NAT and making first interface bridged with "${NC}
#set -vx
for vagrantM in ${filter_machines_offvagm}; do
 for vboxM in $(VBoxManage list vms | grep -v inaccessible | grep $vagrantM | grep $filter_machines_local_directory | cut -d'"' -f2  ); do
  #VBoxManage showvminfo $M | grep -i nic    #"--machinereadable"
  VBoxManage modifyvm $vboxM --nic1 none --nic2 none --nic3 none --nic4 none --nic5 none --nic6 none --nic7 none --nic8 none 
  VBoxManage modifyvm $vboxM --nic1 bridged --bridgeadapter1 $HOST_BRIDGED_INTERFACE --nictype1 82540EM --macaddress1 auto
  #VBoxManage modifyvm $vboxM --nic2 nat --nictype2 82540EM --macaddress2 auto --natnet2 "10.0.2.0/24" --natpf2 "ssh,tcp,127.0.0.1,2222,,22" --natdnsproxy2 off --natdnshostresolver2 off # This is optional
  VBoxManage startvm $vboxM --type headless  # DO NOT USE 'vagrant up', use VBoxManage startvm command
 done
done

###

echo ${Green}"[*] Machines were reconfigured and restarted. This is the vagrant status for virtuabox machines:"${NC}
vagrant status | grep '(virtualbox)'

###
echo ${Green}"[*] Generating a ssh_config to be used by ssh (partially reusing vagrant generated ssh keys and config)"${NC}
all_runningVagrMs=$(vagrant status | grep 'running (virtualbox)' | cut -d" " -f1)
rm -f ssh_config
for runningVagrM in $all_runningVagrMs ; do
  vagrant ssh-config $runningVagrM | sed "s|^ *HostName .*|  HostName $runningVagrM|g" | sed "s|^ *Port .*|  Port 22|g" >>ssh_config
done

echo ${Yellow}"[INFO] to ssh into any of the machines, run like this: "${NC}
for M in ${all_runningVagrMs} ; do
  echo "ssh -F ./ssh_config $M "
done
echo
