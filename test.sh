#!/bin/bash
systemctl set-ntp true
echo "[#] Clock Synchronized"
fdisk /dev/sda
p