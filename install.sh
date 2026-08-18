#!/bin/bash
# Reddit Desktop - Universal Linux Installation Script
# Works on Ubuntu, Debian, Fedora, Arch, Kali, and all Linux distributions

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Installing Reddit Desktop...${NC}"

# Determine installation directory
INSTALL_DIR="$HOME/.local/bin"
APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"

# Expand $HOME for use in desktop entry
FULL_PATH="$INSTALL_DIR/reddit-desktop"

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
chmod 755 "$APPIMAGE_PATH"
echo -e "${GREEN}✓ AppImage downloaded and made executable${NC}"

# Download and install icon
echo -e "${YELLOW}🎨 Setting up application icon...${NC}"
ICON_URL="https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/csc-main/Reddit/src/assets/icons/reddit.png"
ICON_PATH="$ICONS_DIR/reddit-desktop.png"

if command -v curl &> /dev/null; then
    curl -fsSL "$ICON_URL" -o "$ICON_PATH" 2>/dev/null || {
        echo -e "${YELLOW}⚠️  Could not download icon, continuing without it${NC}"
    }
elif command -v wget &> /dev/null; then
    wget -q "$ICON_URL" -O "$ICON_PATH" 2>/dev/null || {
        echo -e "${YELLOW}⚠️  Could not download icon, continuing without it${NC}"
    }
fi

# Create desktop entry with full paths
echo -e "${YELLOW}📝 Creating desktop launcher...${NC}"
cat > "$APPS_DIR/reddit-desktop.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Reddit
GenericName=Reddit Client
Comment=Reddit Desktop - Native Reddit Application for Linux
Exec=$FULL_PATH %U
Icon=reddit-desktop
Terminal=false
Categories=Network;WebBrowser;Chat;
StartupNotify=true
StartupWMClass=Reddit
X-GNOME-Usable-Disabled=false
EOF

chmod 644 "$APPS_DIR/reddit-desktop.desktop"
echo -e "${GREEN}✓ Desktop entry created${NC}"

# Update desktop database
echo -e "${YELLOW}🔄 Updating desktop database...${NC}"
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$APPS_DIR" 2>/dev/null || true
    echo -e "${GREEN}✓ Desktop database updated${NC}"
fi

# Update icon cache
echo -e "${YELLOW}🔄 Updating icon cache...${NC}"
if command -v update-icon-caches &> /dev/null; then
    update-icon-caches "$HOME/.local/share/icons/" 2>/dev/null || true
    echo -e "${GREEN}✓ Icon cache updated${NC}"
elif command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor/" 2>/dev/null || true
    echo -e "${GREEN}✓ Icon cache updated${NC}"
fi

# Add to PATH if needed
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo -e "${YELLOW}💡 Adding $INSTALL_DIR to PATH...${NC}"
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "export PATH.*\.local/bin" "$HOME/.bashrc"; then
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.bashrc"
            echo -e "${GREEN}✓ Added to ~/.bashrc${NC}"
        fi
    fi
fi

# Success message
echo ""
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo ""
echo -e "${BLUE}Launch Reddit Desktop in any of these ways:${NC}"
echo -e "  1. ${YELLOW}Search for 'Reddit' in your applications menu${NC}"
echo -e "  2. ${YELLOW}Run:${NC} reddit-desktop"
echo -e "  3. ${YELLOW}Run:${NC} ~/.local/bin/reddit-desktop"
echo ""
echo -e "${BLUE}To uninstall, run:${NC}"
echo -e "  ${YELLOW}curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/uninstall.sh | bash${NC}"
echo ""
echo -e "${BLUE}If the application doesn't appear in your menu:${NC}"
echo -e "  1. Log out and log back in, OR"
echo -e "  2. Run: ${YELLOW}killall -9 plasmashell${NC} (for KDE) or restart your desktop"
echo ""
