#!/bin/bash

# Function to create the subfolders
create_subfolders() {
  local folder="$1"

  # Change into the supplied folder
  cd "$folder" || exit

  # Create subfolders
  mkdir -p "1x1" "1x2" "1x3" "2x1" "2x3" "3x1" "3x2" "3x4" "3x5" "4x3" "4x5" "5x3" "5x4" "9x16" "10x16" "16x9"
}

# Check if a folder argument is provided
if [ $# -eq 0 ]; then
  echo "Please provide a folder as an argument."
  exit 1
fi

# Get the folder path from the argument
folder="$1"

# Check if the folder exists
if [ ! -d "$folder" ]; then
  echo "Folder '$folder' does not exist."
  exit 1
fi

# Run the function to create subfolders
create_subfolders "$folder"

echo "Subfolders created in '$folder'."
