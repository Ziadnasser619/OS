# Antivirus Lab

## Description

A Bash-based antivirus daemon that monitors a directory for changes,
detects suspicious files, and moves them to quarantine.

The project also includes a restore utility that allows users to
restore quarantined files or permanently delete them.

## Project Files

- `antivirusd.sh`: Monitors the directory and scans files.
- `restore.sh`: Restores or permanently deletes quarantined files.
- `test.sh`: Script used for testing file detection.
- `Makefile`: Provides commands for creating directories and running scripts.
- `monitored/`: Directory monitored by the antivirus daemon.
- `malicious_dir/`: Quarantine directory used by the Makefile.

## Requirements

- Bash
- GNU Make

## Setup

Navigate to the project directory and run:

```bash
make
```

This creates the `malicious_dir` directory if it does not exist.

## Running the Antivirus Daemon

Run:

```bash
make daemon
```

The daemon performs an initial scan and then checks the monitored
directory for changes every five seconds.

To stop the daemon, press `Ctrl+C`.

You can also run the daemon directly:

```bash
./antivirusd.sh monitored/ malicious_dir 5
```

## Restoring Quarantined Files

Run:

```bash
make restore
```

Or run the restore script directly:

```bash
./restore.sh monitored/ malicious_dir
```

The script lists quarantined files and allows the user to:

1. Restore a file to the monitored directory.
2. Permanently delete a file.
3. Return to the file list without making changes.

## Cleaning Snapshot Files

Run:

```bash
make clean
```

This removes the directory snapshot files. They will be recreated
when the daemon runs again.
