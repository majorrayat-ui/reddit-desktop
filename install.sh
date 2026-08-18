#!/bin/bash
# Reddit Desktop - Universal Linux Installation Script
# Works on Ubuntu, Debian, Fedora, Arch, Kali, and all Linux distributions

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Installing Reddit Desktop...${NC}"

# Determine installation directory
INSTALL_DIR="$HOME/.local/bin"
APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$APPS_DIR"
mkdir -p "$ICONS_DIR"

# Download latest AppImage
echo -e "${YELLOW}📥 Downloading Reddit Desktop AppImage...${NC}"
RELEASE_URL="https://github.com/majorrayat-ui/reddit-desktop/releases/download/v1.0.0/Reddit-Desktop-1.0.0-x86_64.AppImage"
APPIMAGE_PATH="$INSTALL_DIR/reddit-desktop"

# Try with curl first, fallback to wget
if command -v curl &> /dev/null; then
    curl -fsSL "$RELEASE_URL" -o "$APPIMAGE_PATH" || {
        echo -e "${RED}❌ Failed to download with curl${NC}"
        exit 1
    }
elif command -v wget &> /dev/null; then
    wget -q "$RELEASE_URL" -O "$APPIMAGE_PATH" || {
        echo -e "${RED}❌ Failed to download with wget${NC}"
        exit 1
    }
else
    echo -e "${RED}❌ Neither curl nor wget found. Please install one of them.${NC}"
    exit 1
fi

# Make executable
chmod +x "$APPIMAGE_PATH"
echo -e "${GREEN}✓ AppImage downloaded and made executable${NC}"

# Create desktop entry
echo -e "${YELLOW}🎨 Creating desktop launcher...${NC}"
cat > "$APPS_DIR/reddit-desktop.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Reddit
Comment=Reddit Desktop - Linux Application
Exec=~/.local/bin/reddit-desktop %U
Icon=reddit-desktop
Terminal=false
Categories=Network;WebBrowser;
StartupNotify=true
EOF

echo -e "${GREEN}✓ Desktop entry created${NC}"

# Create symbolic link for command line access
ln -sf "$APPIMAGE_PATH" "$INSTALL_DIR/reddit-desktop-run" 2>/dev/null || true

# Success message
echo ""
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo ""
echo -e "Launch Reddit Desktop in any of these ways:"
echo -e "  1. Search for 'Reddit' in your applications menu"
echo -e "  2. Run: ${YELLOW}reddit-desktop${NC}"
echo -e "  3. Run: ${YELLOW}~/.local/bin/reddit-desktop${NC}"
echo ""
echo -e "To uninstall, run:"
echo -e "  ${YELLOW}curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/uninstall.sh | bash${NC}"
echo ""
