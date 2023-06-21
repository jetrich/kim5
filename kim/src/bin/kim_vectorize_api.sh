#!/bin/bash
# Vectorize script

# Get the absolute path of the script directory
script_dir="/opt/woltje/scripts/"

# Log file path
log_file="$script_dir/vectorize.log"

# Source the variables file
source "$(dirname "${HOME}")/.kim/variables.sh"

# Function to log messages
log() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') $message" >> "$log_file"
}

# Function to vectorize the PNG file
vectorize_png() {
  local png_file="$1"
  local output_dir=$(dirname "$png_file")

  # Get the base name of the PNG file
  basename=$(basename "${png_file%.*}")
  filename=$(basename "${png_file}")
  extension="${filename##*.}"

  # Check if SVG file exists for the PNG
  svg_file="${output_dir}/${basename}.svg"
  if [ ! -f "$svg_file" ]; then
    log "Vectorizing: $filename"

    # Create a progress bar window
    (
      echo "0"
      sleep 0.1
      echo "# Vectorizing: $filename"
      echo "10"
      sleep 0.5

      # Vectorize the PNG file
      curl -s "https://vectorizer.ai/api/v1/vectorize" \
        -u "$vectorizer_username:$vectorizer_password" \
        -F "image=@${png_file}" \
        -o "$svg_file"

      echo "100"
      sleep 0.1
    ) | zenity --progress --title="Vectorizing PNG" --text="Starting..." --percentage=0 --auto-close --width=400

    log "Vectorized: $filename"
  else
    log "SVG file already exists for: $filename"
  fi
}

# Check if the script is run with command-line arguments
if [ $# -eq 1 ]; then
  png_file="$1"
  vectorize_png "$png_file"
else
  # Prompt for the PNG file when running from a submenu
  read -p "Enter the path to the PNG file: " png_file
  vectorize_png "$png_file"
fi
