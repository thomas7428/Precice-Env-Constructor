#!/bin/bash

# Dossier contenant le fichier à découper et où mettre les morceaux
CONSTRUCTOR_DIR="./Constructor"
SOURCE_FILE="$CONSTRUCTOR_DIR/precice_env_installer.sh"
CHUNK_SIZE="90M"

# Vérifie si le fichier source existe
if [ ! -f "$SOURCE_FILE" ]; then
  echo "❌ Le fichier $SOURCE_FILE n'existe pas."
  exit 1
fi

# Supprimer d'anciens morceaux s'il y en a
echo "🧹 Suppression des anciens morceaux éventuels dans $CONSTRUCTOR_DIR..."
rm -f "$CONSTRUCTOR_DIR"/part_*

# Découpe le fichier
echo "✂️ Découpage de $SOURCE_FILE en morceaux de $CHUNK_SIZE..."
split -b "$CHUNK_SIZE" "$SOURCE_FILE" "$CONSTRUCTOR_DIR/part_"

echo "✅ Découpage terminé. Morceaux placés dans $CONSTRUCTOR_DIR/"
