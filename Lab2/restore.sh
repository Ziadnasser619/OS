#!/bin/bash

monitored_dir="$1"
quarantine_dir="$2"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <monitored_dir> <quarantine_dir>"
    exit 1
fi

if [ ! -d "$monitored_dir" ]; then
    echo "Monitored directory doesn't exist"
    exit 1
fi

if [ ! -d "$quarantine_dir" ]; then
    echo "Quarantine directory doesn't exist"
    exit 1
fi

while true
do
    files=()

    for file in "$quarantine_dir"/*
    do
        if [ -f "$file" ]; then
            files+=("$file")
        fi
    done

    if [ "${#files[@]}" -eq 0 ]; then
        echo "Quarantine is empty"
        exit 0
    fi

    echo
    echo "Quarantined files:"

    for i in "${!files[@]}"
    do
        echo "$((i + 1)). ${files[$i]##*/}"
    done

    echo "0. Exit"
    read -r -p "Choose a file number: " choice

    if [ "$choice" = "0" ]; then
        exit 0
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] ||
       [ "$choice" -lt 1 ] ||
       [ "$choice" -gt "${#files[@]}" ]; then
        echo "Invalid choice"
        continue
    fi

    selected_file="${files[$((choice - 1))]}"
    filename="${selected_file##*/}"

    echo
    echo "Selected: $filename"
    echo "1. Restore file"
    echo "2. Permanently delete file"
    echo "3. Return to file list"

    read -r -p "Choose an action: " action

    case "$action" in
        1)
            if [ -e "$monitored_dir/$filename" ]; then
                echo "A file with this name already exists in the monitored directory"
            elif mv -- "$selected_file" "$monitored_dir/"; then
                echo "$filename restored successfully"
            else
                echo "Failed to restore $filename"
            fi
            ;;
        2)
            read -r -p "Permanently delete $filename? (y/n): " confirm

            if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                if rm -- "$selected_file"; then
                    echo "$filename deleted permanently"
                else
                    echo "Failed to delete $filename"
                fi
            else
                echo "Deletion cancelled"
            fi
            ;;
        3)
            echo "Returning to file list"
            ;;
        *)
            echo "Invalid action"
            ;;
    esac
done
