#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Use the first argument as the rclone remote, or fall back to the default
RCLONE_REMOTE="ftp.dbit.com"

# Define source and destination paths
SOURCE_DIR="$SCRIPT_DIR/source/"
DEST_DIR="$SCRIPT_DIR/_mirror/$RCLONE_REMOTE/"
BACK_DIR="$SCRIPT_DIR/_mirror/deleted_$(date +%Y-%m-%d_%H-%M)/"

# Create Backup Dir
echo "Creating Backup Dir $BACK_DIR"
mkdir -p "$BACK_DIR"

# Sync files from the source to the destination
echo "Starting rclone sync from $RCLONE_REMOTE to $DEST_DIR..."
rclone sync "$RCLONE_REMOTE:/" "$DEST_DIR" --backup-dir="$BACK_DIR" --progress --tpslimit 10

echo "Rclone sync operation is complete."
