#!/bin/bash
clear
echo "                                               __            ___                        "
echo "                                              /\ \__        /\_ \                       "
echo "    __     __      ____  __  __    ___      __\ \ ,_\  _____\//\ \      __      ___     "
echo "  /'__`\ /'__`\   /',__\/\ \/\ \ /' _ `\  /'__`\ \ \/ /\ '__`\\ \ \   /'__`\  /' _ `\   "
echo " /\  __//\ \L\.\_/\__, `\ \ \_\ \/\ \/\ \/\  __/\ \ \_\ \ \L\ \\_\ \_/\ \L\.\_/\ \/\ \  "
echo " \ \____\ \__/.\_\/\____/\/`____ \ \_\ \_\ \____\\ \__\\ \ ,__//\____\ \__/.\_\ \_\ \_\ "
echo "  \/____/\/__/\/_/\/___/  `/___/> \/_/\/_/\/____/ \/__/ \ \ \/ \/____/\/__/\/_/\/_/\/_/ "
echo "                             /\___/                      \ \_\                          "
echo "                             \/__/                        \/_/                          "
echo ""
echo "IP & DNS Configuration"
echo ""
read -p "New IP. Example: 192.168.1.240/24: " IP_ADDRESS
read -p "Gateway. Example: 192.168.1.1: " GATEWAY_ADDRESS
read -p "First DNS. Example: 8.8.8.8: " PRIMARY_DNS_ADDRESS
read -p "Second DNS. Example: 1.1.1.1: " SECONDARY_DNS_ADDRESS
ethname=$(ip -o link show | sed -rn '/^[0-9]+: en/{s/.: ([^:]*):.*/\1/p}')
sudo rm -rf ~/99-custom.yaml
sudo touch ~/99-custom.yaml
echo "network:" >> ~/99-custom.yaml
echo "  version: 2" >> ~/99-custom.yaml
echo "  renderer: networkd" >> ~/99-custom.yaml
echo "  ethernets:" >> ~/99-custom.yaml
echo "    $ethname:" >> ~/99-custom.yaml
echo "     dhcp4: no" >> ~/99-custom.yaml
echo "     addresses:" >> ~/99-custom.yaml
echo "      - $IP_ADDRESS" >> ~/99-custom.yaml
echo "     routes:" >> ~/99-custom.yaml
echo "      - to: default" >> ~/99-custom.yaml
echo "        via: $GATEWAY_ADDRESS" >> ~/99-custom.yaml
echo "     nameservers:" >> ~/99-custom.yaml
echo "       addresses: [$PRIMARY_DNS_ADDRESS, $SECONDARY_DNS_ADDRESS]" >> ~/99-custom.yaml
sudo rm -rf /etc/netplan/*
sudo mv ~/99-custom.yaml /etc/netplan/99-custom.yaml
clear
echo "                                               __            ___                        "
echo "                                              /\ \__        /\_ \                       "
echo "    __     __      ____  __  __    ___      __\ \ ,_\  _____\//\ \      __      ___     "
echo "  /'__`\ /'__`\   /',__\/\ \/\ \ /' _ `\  /'__`\ \ \/ /\ '__`\\ \ \   /'__`\  /' _ `\   "
echo " /\  __//\ \L\.\_/\__, `\ \ \_\ \/\ \/\ \/\  __/\ \ \_\ \ \L\ \\_\ \_/\ \L\.\_/\ \/\ \  "
echo " \ \____\ \__/.\_\/\____/\/`____ \ \_\ \_\ \____\\ \__\\ \ ,__//\____\ \__/.\_\ \_\ \_\ "
echo "  \/____/\/__/\/_/\/___/  `/___/> \/_/\/_/\/____/ \/__/ \ \ \/ \/____/\/__/\/_/\/_/\/_/ "
echo "                             /\___/                      \ \_\                          "
echo "                             \/__/                        \/_/                          "
echo ""
echo "Attention! Below are your new IP and DNS settings. Do not apply without checking!"
echo "IP: $IP_ADDRESS"
echo "GATEWAY: $GATEWAY_ADDRESS"
echo "DNS: $PRIMARY_DNS_ADDRESS / $SECONDARY_DNS_ADDRESS"
echo ""
while true; do
    read -p "Are you sure you want to apply the IP & DNS settings? (y/n)" yn
    case $yn in
        [Yy]* ) sudo netplan apply; break;;
        [Nn]* ) exit;;
        * ) echo "You pressed an invalid character. Try again.";;
    esac
done
