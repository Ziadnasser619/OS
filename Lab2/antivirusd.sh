#!/bin/bash

monitored_dir="$1"
quarantine_dir="$2"
interval="$3"

if [ "$#" -ne 3 ]; then
    echo "wrong usage"
    echo "Usage: $0 <monitored_dir> <quarantine_dir> <interval-secs>"
    exit 1
fi

if [ ! -d "$monitored_dir" ]; then
    echo "directory doesn't exist"
    exit 1
fi

if [ ! -d "$quarantine_dir" ]; then
    echo "directory doesn't exist"
    exit 1
fi

if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
    echo "interval must be a positive integer"
    exit 1
fi

if [ "$interval" -le 0 ]; then
    echo "interval must be greater than zero"
    exit 1
fi

echo "Monitored directory: $monitored_dir"
echo "Quarantine directory: $quarantine_dir"
echo "Interval: $interval"

scan_directory() {
    for file in "$monitored_dir"/*
    do
        if [ -f "$file" ]; then
            malicious=0

            if grep -qiE 'virus|trojan|malware|worm|ransomware' "$file"; then
                malicious=1
            fi

            case "${file##*.}" in
                exe|bat|vbs|scr|ps1)
                    malicious=1
                    ;;
            esac

            if [ "$malicious" -eq 1 ]; then
                if cp "$file" "$quarantine_dir/"; then
                    if rm "$file"; then
                        echo "${file##*/} is malicious and it is DELETED"
                    else
                        echo "Failed to delete ${file##*/}"
                    fi
                else
                    echo "Failed to quarantine ${file##*/}"
                fi
            fi
        fi
    done
}

echo "Initial scan started"
scan_directory
echo "Initial scan completed"

ls -l "$monitored_dir" > directory-info.last

while true
do
    sleep "$interval"

    ls -l "$monitored_dir" > directory-info.new

    if diff -q directory-info.last directory-info.new > /dev/null; then
        echo "No changes detected"
    else
        echo "Changes detected"
        scan_directory
    fi

    ls -l "$monitored_dir" > directory-info.last
done
