# Antivirus Lab

## Overview

This project uses Bash to monitor a directory, detect suspicious files, and move them to quarantine. The restore tool lets the user restore a file or delete it permanently. A Cron script is also included for scheduled scans.

## Folder Structure

```text
Lab2/
├── antivirusd.sh       # Antivirus daemon
├── antivirus-cron.sh   # One-time scan for Cron
├── restore.sh          # Restore or delete quarantined files
├── test.sh             # Test script
├── Makefile             # Commands for setup and running tools
├── README.md
├── monitored/           # Files to scan
├── malicious_dir/       # Quarantined files
├── directory-info.last  # Previous directory snapshot (generated)
├── directory-info.new   # Current directory snapshot (generated)
└── cron.log             # Cron output (created when used)
```

## Requirements and Installation

The scripts need Ubuntu and Bash. GNU Make is used for the provided commands. Cron is optional and only needed for scheduled scans.

```bash
sudo apt update
sudo apt install make cron
sudo systemctl enable --now cron
```

Bash is normally already installed on Ubuntu.

## Setup

Open a terminal in the project folder, then run:

```bash
chmod +x antivirusd.sh antivirus-cron.sh restore.sh test.sh
make
```

`make` creates the quarantine folder if it does not exist.

## Run the Antivirus

Start the daemon with:

```bash
make daemon
```

It scans the `monitored/` folder and checks for changes every five seconds. Press `Ctrl+C` to stop it.

You can also run it directly:

```bash
./antivirusd.sh monitored/ malicious_dir/ 5
```

## Run the Restore Tool

Run:

```bash
make restore
```

Or run it directly:

```bash
./restore.sh monitored/ malicious_dir/
```

Choose a quarantined file, then select whether to restore it, delete it permanently, or leave it unchanged.

## Detection Rules

Both required lists are defined in `antivirusd.sh`, inside the `scan_directory()` function:

- **Flagged extensions:** in the `case` statement — `.exe`, `.bat`, `.vbs`, `.scr`, `.ps1`
- **Flagged keywords:** in the `grep -qiE` command — `virus`, `trojan`, `malware`, `worm`, `ransomware`

Keyword matching ignores uppercase and lowercase. A file is quarantined if its extension or its contents match a rule.

## Optional: Cron Scan

`antivirus-cron.sh` performs one scan each time it runs. Cron can be configured to run it repeatedly. Check the script and use absolute paths when adding it to `crontab -e`.
