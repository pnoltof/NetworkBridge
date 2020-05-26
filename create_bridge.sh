#!/bin/bash
#Firstly, create a bridge on the host machine:
sudo ip link add br0 type bridge
#If you want to use already created bridge don't forget to clean out IP.
sudo ip addr flush dev br0
#Assign IP to the bridge.
sudo ip addr add 192.168.100.50/24 brd 192.168.100.255 dev br0
#Create TAP interface.
sudo ip tuntap add mode tap user $(whoami)
#ip tuntap show
#Output should contains name of created TAP interface:
#~ tap0: tap UNKNOWN_FLAGS:800 user 1000
#Add TAP interface to the bridge.
sudo ip link set tap0 master br0
#Make sure everything is up:
sudo ip link set dev br0 up
sudo ip link set dev tap0 up
#Assign IP range to the bridge.
sudo dnsmasq --interface=br0 --bind-interfaces --dhcp-range=192.168.100.50,192.168.100.254

#Enable qemu to use the bridge:
sudo mkdir /etc/qemu
sudo touch /etc/qemu/bridge.conf
sudo bash -c 'echo "allow br0" > /etc/qemu/bridge.conf'

#start client with -net nic,model=rtl8139 -net bridge,br=br0
#In the guest system assign static IP address to the network interface:
#ip addr add 192.168.100.224/24 broadcast 192.168.100.255 dev eth0
#or: ifconfig eth0 192.168.100.224 netmask 255.255.255.0 up

#to start without sudo qemu-bridge-helper needs to be a suid binary (sudo chmod u+s /usr/lib/qemu-bridge-helper)
