#!/bin/bash
# Check Dependencies script

# Source the variables file
source "$(dirname "${HOME}")/.kim/variables.sh"

# Check if Inkscape is installed
if ! command -v inkscape &>/dev/null; then
    echo "Error: Inkscape is not installed. Please install Inkscape to use this script."
    exit 1
fi

# Check if ImageMagick is installed
if ! command -v convert &>/dev/null; then
    echo "Error: ImageMagick is not installed. Please install ImageMagick to use this script."
    exit 1
fi

# Check if curl is installed
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed. Please install curl to use this script."
    exit 1
fi

echo "All dependencies are installed."
