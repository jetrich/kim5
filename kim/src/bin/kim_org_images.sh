#!/bin/bash

# Function to create a folder if it doesn't exist
create_folder_if_not_exists() {
    local folder="$1"
    mkdir -p "$folder"
}

# Function to move files to a folder
move_files_to_folder() {
    local source_dir="$1"
    local destination_dir="$2"
    local file_ext="$3"

    find "$source_dir" -maxdepth 1 -type f -iname "*.$file_ext" -print0 | while IFS= read -r -d '' file; do
        base_name=$(basename "$file")
        mv "$file" "$destination_dir/$base_name"
    done
}

# Check if the directory argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide a directory as an argument."
    exit 1
fi

# Extract the directory from the argument
directory="$1"

# Search for png, jpg, svg, and xcf files in the directory (limiting to maxdepth 1)
find "$directory" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.svg" -o -iname "*.xcf" \) -print0 | while IFS= read -r -d '' file; do
    # Get the base name of the file
    base_name=$(basename "$file")

    # Get the directory name of the file
    file_dir=$(dirname "$file")

    # Create the folder with the image basename if it doesn't exist
    folder_name="${base_name%.*}"
    create_folder_if_not_exists "$file_dir/$folder_name"

    # Move the image file to the 'originals' folder
    if [[ "$base_name" == *.png || "$base_name" == *.jpg ]]; then
        create_folder_if_not_exists "$file_dir/originals"
        cp "$file" "$file_dir/originals"
    fi
    
    # Move the file to the new folder
    mv "$file" "$file_dir/$folder_name"

done


echo "Image files in '$directory' have been organized."
