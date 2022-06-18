#!/bin/bash

# Kernel Software Interruption
pgrep ksoftirqd |
while read in; do
    renice -n -14 -p $in
done

# Zerotier one
pgrep zerotier-one |
while read in; do
    renice -n -14 -p $in
done

# WireGuard
pgrep wg-crypt |
while read in; do
    renice -n -14 -p $in
done

# Softether VPN
pgrep vpnserver |
while read in; do
    renice -n -14 -p $in
done

# Nginx
pgrep nginx |
while read in; do
    renice -n -12 -p $in
done

# PHP
pgrep php-fpm |
while read in; do
    renice -n -12 -p $in
done