#!/bin/bash
# Generate PNG icons from SVG source

set -e

ICON_DIR="src/assets/icons"
SVG_FILE="$ICON_DIR/reddit.svg"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick is required to generate icons"
    echo "Install with: sudo apt-get install imagemagick"
    exit 1
fi

# Check if SVG file exists
if [ ! -f "$SVG_FILE" ]; then
    echo "Error: SVG source file not found at $SVG_FILE"
    exit 1
fi

# Define icon sizes
SIZES=(16 24 32 48 64 128 256 512)

echo "Generating PNG icons from SVG source..."

# Generate PNG files for each size
for size in "${SIZES[@]}"; do
    OUTPUT_FILE="$ICON_DIR/${size}.png"
    
    if command -v magick &> /dev/null; then
        # ImageMagick 7.x
        magick convert "$SVG_FILE" -density 300 -resize "${size}x${size}" "$OUTPUT_FILE"
    else
        # ImageMagick 6.x
        convert "$SVG_FILE" -density 300 -resize "${size}x${size}" "$OUTPUT_FILE"
    fi
    
    echo "✓ Generated $OUTPUT_FILE (${size}x${size})"
done

echo ""
echo "✓ All icons generated successfully!"
echo "Icons are ready in: $ICON_DIR"
