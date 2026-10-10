#!/bin/bash

monitored_dir="monitored"
quarantine_dir="quarantine"

for file in "$monitored_dir"/*
do
    if [ -f "$file" ]; then
        malicious=0

        if grep -qiE 'virus|trojan|malware|worm|ransomware' "$file"; then
            malicious=1
        fi

        case "${file##*.}" in
            exe)
                malicious=1
                ;;
            bat)
                malicious=1
                ;;
            vbs)
                malicious=1
                ;;
            scr)
                malicious=1
                ;;
            ps1)
                malicious=1
                ;;
            *)
                ;;
        esac

        if [ "$malicious" -eq 1 ]; then
            echo "$file"
            echo "$file is malicious and it is DELETED"

            if cp "$file" "$quarantine_dir/"; then
                echo "Copy successful"
                rm "$file"
            else
                echo "Copy failed"
            fi
        else
            echo "$file"
            echo "file is safe"
        fi
    fi
done
