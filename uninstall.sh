#!/bin/bash
# Reddit Desktop - Universal Linux Uninstallation Script
# Works on Ubuntu, Debian, Fedora, Arch, Kali, and all Linux distributions

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🗑️  Removing Reddit Desktop...${NC}"

# Directories
INSTALL_DIR="$HOME/.local/bin"
APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"
CONFIG_DIR="$HOME/.config/Reddit"

# Remove AppImage
if [ -f "$INSTALL_DIR/reddit-desktop" ]; then
    rm -f "$INSTALL_DIR/reddit-desktop"
    echo -e "${GREEN}✓ AppImage removed${NC}"
fi

# Remove desktop entry
if [ -f "$APPS_DIR/reddit-desktop.desktop" ]; then
    rm -f "$APPS_DIR/reddit-desktop.desktop"
    echo -e "${GREEN}✓ Desktop launcher removed${NC}"
fi

# Remove icon files
if [ -f "$ICONS_DIR/reddit-desktop.png" ]; then
    rm -f "$ICONS_DIR/reddit-desktop.png"
    echo -e "${GREEN}✓ Application icon removed${NC}"
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

# Update desktop database
echo -e "${YELLOW}🔄 Updating desktop database...${NC}"
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$APPS_DIR" 2>/dev/null || true
    echo -e "${GREEN}✓ Desktop database updated${NC}"
fi

# Update icon cache
echo -e "${YELLOW}🔄 Updating icon cache...${NC}"
if command -v update-icon-caches &> /dev/null; then
    update-icon-caches ~/.local/share/icons/ 2>/dev/null || true
    echo -e "${GREEN}✓ Icon cache updated${NC}"
elif command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor/ 2>/dev/null || true
    echo -e "${GREEN}✓ Icon cache updated${NC}"
fi

echo ""
echo -e "${GREEN}✅ Uninstallation Complete!${NC}"
echo ""
echo -e "${BLUE}Reddit Desktop has been removed from your system.${NC}"
echo ""
echo -e "If the application still appears in your menu after uninstalling:"
echo -e "  1. Log out and log back in, OR"
echo -e "  2. Restart your system"
echo ""
echo -e "To reinstall, run:"
echo -e "  ${YELLOW}curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash${NC}"
echo ""
