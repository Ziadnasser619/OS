#!/bin/bash

monitored_dir="$1"
quarantine_dir="$2"

if [ "$#" -ne 2 ]; then
    echo "wrong usage"
    echo "Usage: $0 <monitored_dir> <quarantine_dir> "
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

echo "Monitored directory: $monitored_dir"
echo "Quarantine directory: $quarantine_dir"

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

scan_directory

