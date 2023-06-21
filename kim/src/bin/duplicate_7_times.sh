#!/bin/bash
# Duplicate Image Script

# Get the selected image file from the command line argument
image_file="$1"

# Check if the provided file is an image file
if [[ "$image_file" =~ \.(png|jpg|jpeg|gif|bmp)$ ]]; then
    # Get the base name and extension of the image file
    base_name="${image_file%.*}"
    extension="${image_file##*.}"

    # Duplicate the image file 7 times and append the name with incrementing integers
    for ((i=1; i<=7; i++)); do
        new_file="${base_name}_${i}.${extension}"
        cp "$image_file" "$new_file"
        echo "Duplicated: $image_file -> $new_file"
    done
else
    echo "Please provide a valid image file."
fi
