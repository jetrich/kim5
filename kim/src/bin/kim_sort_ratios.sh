#!/bin/bash

# Check if the directory argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide a directory as an argument."
    exit 1
fi

# Extract the directory from the argument
directory="$1"

# Function to compute the greatest common divisor (GCD)
gcd() {
    if [ $2 -eq 0 ]; then
        echo $1
    else
        echo $(gcd $2 $(($1 % $2)))
    fi
}

# Search for png files in the directory
find "$directory" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.svg" \) -print0 | while IFS= read -r -d '' file; do
    # Get the width and height of the image
    dimensions=$(identify -format "%wx%h" "$file")
    width=${dimensions%x*}
    height=${dimensions#*x}

    # Compute the simplified ratio
    divisor=$(gcd $width $height)
    simplified_width=$((width / divisor))
    simplified_height=$((height / divisor))

    # Create the folder with the simplified ratio if it doesn't exist
    ratio_folder="${directory}/${simplified_width}:${simplified_height}"
    mkdir -p "$ratio_folder"

    # Move the image file to the new folder
    mv "$file" "$ratio_folder"
done

echo "Image files in '$directory' have been organized."
