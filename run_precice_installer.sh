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

echo "✅ $FINAL_SCRIPT executed successfully."

# Permissions for post_install_script.sh
echo "🔒 Setting permissions for post_install_script.sh..."
chmod +x "post_install_script.sh"
echo "✅ Permissions set."

# Inform that they will need to use the post_install_script.sh manually after initialization and activation of the environment
echo "⚠️ Please remember to run the post_install_script.sh manually after initializing and activating the environment."
echo "To do this, use the following command:"
echo "   source ~/miniconda3/etc/profile.d/conda.csh"
echo "   conda init"
echo "   conda activate precice_env"
echo "   ./post_install_script.sh"