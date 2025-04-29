#!/bin/bash

# Directory containing the file to split and where to place the chunks
CONSTRUCTOR_DIR="./"
SOURCE_FILE="precice_env_installer.sh"
CHUNK_SIZE="90M"

# Create the construct via constructor
echo "🛠️ Creating the installer using Constructor..."
constructor . --platform=linux-64 -v
echo "✅ Installer created successfully."

# Remove temp and sd
echo "🧹 Removing temp and sd folders..."
rm -rf temp
rm -rf sd
echo "✅ Temp and sd folders removed."

# Check if the source file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo "❌ The file $SOURCE_FILE does not exist."
  exit 1
fi

# Remove old chunks if any
echo "🧹 Removing old chunks in $CONSTRUCTOR_DIR..."
rm -f "$CONSTRUCTOR_DIR"/part_*

# Split the file
echo "✂️ Splitting $SOURCE_FILE into chunks of $CHUNK_SIZE..."
split -b "$CHUNK_SIZE" "$SOURCE_FILE" "$CONSTRUCTOR_DIR/part_"

# Remove the original file
echo "🗑️ Removing the original file $SOURCE_FILE..."
rm -rf $SOURCE_FILE
echo "✅ Original file removed."


echo "✅ Splitting completed. Chunks placed in $CONSTRUCTOR_DIR/"
