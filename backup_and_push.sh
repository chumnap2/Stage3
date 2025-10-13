#!/bin/bash
# -----------------------------
# One-command backup and push to GitHub
# -----------------------------

# Exit on any error
set -e

# Get current timestamp
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Stage all changes
git add .

# Commit with timestamp
git commit -m "Backup: $TIMESTAMP"

# Push to main branch
git push origin main

echo "[INFO] Backup complete: $TIMESTAMP"
