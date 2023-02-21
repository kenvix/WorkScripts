#!/bin/bash
set -e

# check /dev/shm/wsl_booted exist
if [ -f /dev/shm/wsl_booted ]; then
    exit 0
fi


echo "[WslBoot] Starting all services listed on EnabledServices.txt ..." >&1

cd "$(cd "$(dirname "$0")" && pwd)" || exit 2

# check EnabledServices exist
if [ ! -f ./EnabledServices.txt ]; then
    echo "[WslBoot] EnabledServices.txt not found" >&2
    exit 1
else
    # read ./EnabledServices.txt line by line and call service "$line" start
    while IFS= read -r line || [[ -n "$line" ]]; do
        serv=$(echo "$line" | cut -d' ' -f1)
        # check line is not empty
        if [ -z "$serv" ]; then
            continue
        fi
        echo "[WslBoot] Starting $serv" >&2
        service $serv start
    done <./EnabledServices.txt

    echo > /dev/shm/wsl_booted
fi
