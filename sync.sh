#!/bin/bash
TPSLIM=5
BWLIM=1000
USE_RSYNC=0
# Get the directory of the script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Use the first argument as the rclone remote, or fall back to the default
RCLONE_REMOTE=""

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


if [ "$USE_RSYNC" -eq 0 ]; then
  RCLONE VARIANT
   Sync files from the source to the destination
  echo "Starting rclone sync from $RCLONE_REMOTE to $DEST_DIR..."
  rclone sync "$RCLONE_REMOTE:/" "$DEST_DIR" --backup-dir="$BACK_DIR" --log-file=$LOG_DIR/$(date +%Y-%m-%d_%H-%M).log --log-level=INFO --progress --tpslimit $TPSLIM --bwlimit $BWLIM --transfers 1 --checkers 1 --timeout 30s --retries 3
  echo "Rclone sync operation is complete."

else

  #RSYNC ALTERNATIVE
  MOUNT_POINT="$SCRIPT_DIR/source"
  mkdir -p "$MOUNT_POINT"
  # Mount the remote storage
  rclone mount "$RCLONE_REMOTE:" "$MOUNT_POINT" --vfs-cache-mode writes --allow-other --log-file="$LOG_DIR/$(date +%Y-%m-%d_%H-%M)_mount.log" --log-level INFO --bwlimit $BWLIM &
  MOUNT_PID=$!
  
  # Wait for the mount to complete (you can adjust the sleep duration)
  sleep 5
  
  # Check if the mount was successful
  if ! mount | grep "$MOUNT_POINT" > /dev/null; then
    echo "Failed to mount remote storage. Exiting."
    kill $MOUNT_PID
    exit 1
  fi
  
  # Run rsync to sync files from the mounted remote to the destination
  rsync -av --progress --timeout=30 --bwlimit $BWLIM --delete --backup --backup-dir="$BACK_DIR" --log-file="$LOG_DIR/$(date +%Y-%m-%d_%H-%M).log" "$MOUNT_POINT/" "$DEST_DIR/"
  
  # Unmount the remote storage
  fusermount -u "$MOUNT_POINT"
  if [ $? -eq 0 ]; then
    echo "Successfully unmounted the remote storage."
  else
    echo "Failed to unmount the remote storage."
  fi
fi
