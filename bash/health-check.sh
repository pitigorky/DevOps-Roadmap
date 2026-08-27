#!/bin/bash

HOSTNAME=$(hostname)
DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "=================================="
echo " SYSTEM HEALTH CHECK"
echo " Host: $HOSTNAME"
echo " Date: $DATE"
echo "=================================="

echo
echo "Hostname:"
hostname

echo
echo "Uptime:"
uptime -p

echo
echo "IP addresses:"
ip -br a

echo
echo "Memory:"
free -h

echo
echo "Disk usage:"
df -h /

echo
echo "Failed services:"
systemctl --failed --no-pager

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo
echo "Disk usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%"
else
    echo "OK: Disk usage is below 80%"
fi

echo
echo "VMware Tools:"

if systemctl is-active --quiet open-vm-tools; then
    echo "OK: open-vm-tools is running"
else
    echo "ERROR: open-vm-tools is not running"
fi

echo
echo "SSH status:"

if systemctl is-active --quiet ssh.socket; then
    echo "OK: SSH socket is active"
else
    echo "ERROR: SSH socket is not active"
fi
