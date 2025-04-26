#!/bin/bash

# Chemin vers le dossier contenant les morceaux
CONSTRUCTOR_DIR="./Constructor"
FINAL_SCRIPT="precice_env_installer.sh"

echo "🔧 Reconstitution de $FINAL_SCRIPT dans $CONSTRUCTOR_DIR..."
cat "$CONSTRUCTOR_DIR"/part_* > "$CONSTRUCTOR_DIR/$FINAL_SCRIPT"

echo "🔐 Attribution des droits d'exécution à $FINAL_SCRIPT..."
chmod +x "$CONSTRUCTOR_DIR/$FINAL_SCRIPT"

echo "🚀 Lancement de $FINAL_SCRIPT..."
"$CONSTRUCTOR_DIR/$FINAL_SCRIPT"
