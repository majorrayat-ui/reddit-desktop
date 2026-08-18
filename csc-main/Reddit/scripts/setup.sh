#!/bin/bash
# Setup and installation script for Reddit Desktop development and building

set -e

echo "🚀 Reddit Desktop Setup"
echo "======================="
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed"
    echo "   Install from: https://nodejs.org/"
    exit 1
fi

echo "✓ Node.js: $(node --version)"

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is required but not installed"
    exit 1
fi

echo "✓ npm: $(npm --version)"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Check for ImageMagick (optional but recommended)
if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
    echo ""
    echo "⚠️  ImageMagick not found (optional but recommended)"
    echo "   To generate application icons, install:"
    echo "   Ubuntu/Debian: sudo apt-get install imagemagick"
    echo "   Fedora/RHEL: sudo dnf install ImageMagick"
    echo "   Arch: sudo pacman -S imagemagick"
else
    echo "✓ ImageMagick is installed"
    
    # Generate icons if they don't exist
    if [ ! -f "src/assets/icons/512.png" ]; then
        echo ""
        echo "🎨 Generating application icons..."
        bash scripts/generate-icons.sh
    fi
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📖 Next steps:"
echo ""
echo "   Development:"
echo "   $ npm run dev              # Run with logging"
echo "   $ npm run dev              # Standard development mode"
echo ""
echo "   Building:"
echo "   $ npm run package          # Build all Linux packages"
echo "   $ npm run build -- --linux AppImage  # AppImage only"
echo "   $ npm run build -- --linux deb       # Debian package only"
echo ""
echo "   Validation:"
echo "   $ npm run validate         # Check syntax"
echo ""
