#!/bin/bash
# Remove "-page001" script

dir="$1"

# Iterate over all files in the provided directory
for file in "$dir"/*; do
    # Check if the file is a regular file
    if [ -f "$file" ]; then
        # Get the base name of the file
        basename=$(basename "$file")

        # Check if the file name contains "-page001"
        if [[ "$basename" == *"-page001"* ]]; then
            # Rename the file by removing "-page001" from the name
            new_name="${basename/-page001/}"
            mv "$file" "$dir/$new_name"
            echo "Renamed: $basename -> $new_name"
        else
            echo "No action needed for: $basename"
        fi
    fi
done
