#!/bin/bash

# Path to the folder containing the parts
CONSTRUCTOR_DIR="./Constructor"
FINAL_SCRIPT="precice_env_installer.sh"

echo "🔧 Reassembling $FINAL_SCRIPT in $CONSTRUCTOR_DIR..."
cat "$CONSTRUCTOR_DIR"/part_* > "$CONSTRUCTOR_DIR/$FINAL_SCRIPT"

echo "🔐 Granting execution rights to $FINAL_SCRIPT..."
chmod +x "$CONSTRUCTOR_DIR/$FINAL_SCRIPT"

echo "🚀 Launching $FINAL_SCRIPT..."
"$CONSTRUCTOR_DIR/$FINAL_SCRIPT"
