#!/bin/bash

# Kernel Software Interruption
pgrep ksoftirqd |
while read in; do
    renice -n -13 -p $in
done

# Zerotier one
pgrep zerotier-one |
while read in; do
    renice -n -13 -p $in
done

# WireGuard
pgrep wg-crypt |
while read in; do
    renice -n -13 -p $in
done