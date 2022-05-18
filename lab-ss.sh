#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward

socat TCP4-LISTEN:15000,fork TCP4:192.168.192.1:15000

LabForwardTarget="192.168.192.1"

iptables -t nat -A PREROUTING -p tcp --dport 15000 -j DNAT --to-destination $LabForwardTarget:15000
iptables -A FORWARD -p tcp -d $LabForwardTarget --dport 15000 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT