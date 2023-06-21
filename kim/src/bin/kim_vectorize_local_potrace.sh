#!/bin/bash
# Vectorize script using potrace

# Get the absolute path of the script directory
# script_dir="/opt/woltje/scripts/"

# Source the variables file
source "$(dirname "${HOME}")/.kim/variables.sh"

# Function to vectorize the PNG file using potrace
vectorize_png_potrace() {
  local png_file="$1"
  local output_dir=$(dirname "$png_file")

  # Get the base name of the PNG file
  basename=$(basename "${png_file%.*}")
  filename=$(basename "${png_file}")
  extension="${filename##*.}"

  # Check if SVG file exists for the PNG
  svg_file="${output_dir}/${basename}__potrace.svg"
  if [ ! -f "$svg_file" ]; then
    # Create a progress bar window
    (
      echo "0"
      sleep 0.1
      echo "# Converting to BMP: $filename"
      echo "10"
      sleep 0.5

      # Convert the PNG file to BMP format
      bmp_file="${output_dir}/${basename}.bmp"
      convert "$png_file" "$bmp_file"

      echo "50"
      sleep 0.1
      echo "# Vectorizing: $filename"
      echo "60"
      sleep 0.5

      # Vectorize the BMP file using potrace
      potrace "$bmp_file" -s -o "$svg_file"

      echo "90"
      sleep 0.1
      echo "# Removing BMP: $filename"
      echo "100"
      sleep 0.5

      # Remove the BMP file
      rm "$bmp_file"

      sleep 0.1
    ) | zenity --progress --title="Vectorizing PNG" --text="Starting..." --percentage=0 --auto-close --width=300

    echo "Vectorized: $filename"
  else
    echo "SVG file already exists for: $filename"
  fi
}

# Check if the script is run with command-line arguments
if [ $# -eq 1 ]; then
  png_file="$1"
  vectorize_png_potrace "$png_file"
else
  # Prompt for the PNG file when running from a submenu
  read -p "Enter the path to the PNG file: " png_file
  vectorize_png_potrace "$png_file"
fi
