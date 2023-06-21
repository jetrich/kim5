#!/bin/bash
# Rasterize script

# Source the variables file
source "$(dirname "${HOME}")/.kim/variables.sh"

# Get the SVG file, output directory, and watermark image from command line arguments
svg_file="$1"
output_dir="$(dirname "$svg_file")"
output_dir="${output_dir%%%}"  # Remove trailing '%' character, if present
watermark_image="$watermark_file"

# echo "svg_file: $svg_file"
# echo "output_dir: $output_dir"
# exit

# Create a directory with the basename of the SVG file
basename=$(basename "${svg_file%.*}")
output_dir="${output_dir}/${basename}"
mkdir -p "${output_dir}"

# Function to display progress notification
display_progress() {
    local message="$1"
    local percentage="$2"
    notify-send -u normal -t 2000 "Rasterizing SVG" "$message - $percentage%"
}

# Variable to keep track of errors
errors=0

# Count the total number of steps
total_steps=${#pixel_widths[@]}

# Display initial progress notification
display_progress "Starting..." 0

# Rasterize the SVG file at different pixel widths
for ((i=0; i<total_steps; i++)); do
    width=${pixel_widths[i]}
    width_dir="${output_dir}/${width}px"
    mkdir -p "$width_dir"

    # Rasterize the SVG file and save as PNG and JPG
    inkscape -z -o "${width_dir}/${basename}_${width}px.png" -w "$width" "$svg_file" &>/dev/null
    convert "${width_dir}/${basename}_${width}px.png" -quality 90 "${width_dir}/${basename}_${width}px.jpg" &>/dev/null

    if [ -f "${width_dir}/${basename}_${width}px.png" ]; then
        display_progress "Rasterizing ${width}px \n Step $((i+1)) of $total_steps" $(( (i+1) * 100 / total_steps ))

        # Apply watermark if width is greater than 100 pixels
        if [ "$width" -gt 100 ]; then
            if ! "$(dirname "${BASH_SOURCE[0]}")/lib/watermark.sh" "${width_dir}/${basename}_${width}px.png" "$width_dir" "$watermark_image"; then
                errors=$((errors+1))
                notify-send -u critical -t 0 "Rasterizing SVG" "Error occurred while applying watermark to ${width}px"
            fi
        fi
    else
        errors=$((errors+1))
        notify-send -u critical -t 0 "Rasterizing SVG" "Error occurred while rasterizing ${width}px to \n "$width_dir""
    fi
done

# Display completion notification if no errors
if [ "$errors" -eq 0 ]; then
    notify-send -u normal -t 3000 "Rasterizing SVG" "Rasterization completed for: ${basename}.svg"
fi
