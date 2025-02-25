#!/bin/bash
TPSLIM=10
# Get the directory of the script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Use the first argument as the rclone remote, or fall back to the default
RCLONE_REMOTE="ftp.dbit.com"

# Define source and destination paths
MIRROR_DIR="$SCRIPT_DIR/_mirror"
DEST_DIR="$MIRROR_DIR/$RCLONE_REMOTE/"
BACK_DIR="$MIRROR_DIR/deleted_files/deleted_$(date +%Y-%m-%d_%H-%M)/"
LOG_DIR="$MIRROR_DIR/rclone_logfiles/"






# Create Backup Dir
echo "Creating Backup Dir $BACK_DIR"
mkdir -p "$MIRROR_DIR"
mkdir -p "$DEST_DIR"
mkdir -p "$BACK_DIR"
mkdir -p "$LOG_DIR"

# Sync files from the source to the destination
echo "Starting rclone sync from $RCLONE_REMOTE to $DEST_DIR..."
rclone sync "$RCLONE_REMOTE:/" "$DEST_DIR" --backup-dir="$BACK_DIR" --log-file=$LOG_DIR/$(date +%Y-%m-%d_%H-%M).log --log-level=INFO --progress --fast-list --tpslimit $TPSLIM

echo "Rclone sync operation is complete."
