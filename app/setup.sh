#!/usr/bin/env bash

# Author: Per
# Description: Setup script for KaliGuard container

set -e

# Set root password from environment variable
echo "root:$ROOT_PASSWORD" | chpasswd

# Create recon directory if it doesn't exist
mkdir -p $CONTAINER_DATA_DIR

exec "$@" # Prevents container from exiting immediately