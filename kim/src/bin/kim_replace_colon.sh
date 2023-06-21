#!/bin/bash
# Replace ":" with "x" script

dir="$1"

# Function to replace ":" with "x"
replace_colon() {
    local file="$1"
    local new_name="${file//:/x}"
    if [ "$file" != "$new_name" ]; then
        mv "$file" "$new_name"
        echo "Renamed: $file -> $new_name"
    fi
}

# Iterate over all files and directories in the provided directory
find "$dir" -depth | while IFS= read -r file; do
    # Check if the file is a regular file or directory
    if [ -f "$file" ] || [ -d "$file" ]; then
        replace_colon "$file"
    fi
done
