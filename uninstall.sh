#!/bin/bash
# Reddit Desktop - Universal Linux Uninstallation Script
# Works on Ubuntu, Debian, Fedora, Arch, Kali, and all Linux distributions

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🗑️  Removing Reddit Desktop...${NC}"

# Directories
INSTALL_DIR="$HOME/.local/bin"
APPS_DIR="$HOME/.local/share/applications"
CONFIG_DIR="$HOME/.config/Reddit"

# Remove AppImage
if [ -f "$INSTALL_DIR/reddit-desktop" ]; then
    rm -f "$INSTALL_DIR/reddit-desktop"
    echo -e "${GREEN}✓ AppImage removed${NC}"
fi

# Remove symbolic link
if [ -L "$INSTALL_DIR/reddit-desktop-run" ]; then
    rm -f "$INSTALL_DIR/reddit-desktop-run"
fi

# Remove desktop entry
if [ -f "$APPS_DIR/reddit-desktop.desktop" ]; then
    rm -f "$APPS_DIR/reddit-desktop.desktop"
    echo -e "${GREEN}✓ Desktop launcher removed${NC}"
fi

# Remove configuration files (optional - ask user)
if [ -d "$CONFIG_DIR" ]; then
    echo -e "${YELLOW}❓ Remove Reddit Desktop configuration files? (Y/n)${NC}"
    read -r response
    if [[ "$response" == "y" || "$response" == "Y" || -z "$response" ]]; then
        rm -rf "$CONFIG_DIR"
        echo -e "${GREEN}✓ Configuration files removed${NC}"
    else
        echo -e "${YELLOW}⚠️  Configuration files preserved in $CONFIG_DIR${NC}"
    fi
fi

# Update desktop database if available
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$APPS_DIR" 2>/dev/null || true
fi

# Update icon cache if available
if command -v update-icon-caches &> /dev/null; then
    update-icon-caches ~/.local/share/icons/ 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}✅ Uninstallation Complete!${NC}"
echo ""
echo -e "Reddit Desktop has been removed from your system."
echo ""
echo -e "To reinstall, run:"
echo -e "  ${YELLOW}curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash${NC}"
echo ""
