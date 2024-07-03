#!/bin/bash

# User-level rc.local executer // by kenvix
# Loop through all entries in /etc/passwd

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Function to check if a value is a valid integer
is_integer() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Loop through all entries in /etc/passwd
while IFS=: read -r username _ uid _ _ _ home shell; do
    # Check if UID is a valid integer and in the range 1000 to 10000
    if is_integer "$uid" && [ "$uid" -ge 1000 ] && [ "$uid" -le 10000 ] && \
       [[ "$shell" != "/sbin/nologin" && "$shell" != "/bin/false" && "$shell" != "/usr/bin/false" ]] && [ -n "$home" ] && [ -d "$home" ]; then
        # Define the path to the etc directory and rc.local file
        etc_dir="$home/etc"
        rc_local="$etc_dir/rc.local"
        
        # Check if the etc directory exists, if not create it
        if [ ! -d "$etc_dir" ]; then
            mkdir -p "$etc_dir"
            chown $username:$username "$etc_dir"
        fi
        
        # Check if the rc.local file exists
        if [ ! -f "$rc_local" ]; then
            # Create the rc.local file
            touch "$rc_local"
            chown $username:$username "$rc_local"
        else
            # Check if the rc.local file is empty
            if [ ! -s "$rc_local" ]; then
                # Skip this user if the file is empty
                continue
            fi
        fi
        
        # If the script reaches this point, sudo switch to the user and execute the rc.local script asynchronously
        sudo -u $username bash "$rc_local" &
    fi
done < /etc/passwd
