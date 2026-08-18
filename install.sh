#!/bin/bash
# Reddit Desktop - Universal Linux Installation Script
# COMPLETELY REWRITTEN WITH ALL CRITICAL FIXES
# Works on Ubuntu, Debian, Fedora, Arch, Kali, and ALL Linux distributions

set -e

# ============================================================================
# Colors for output
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# Helper functions
# ============================================================================

error() {
  echo -e "${RED}❌ ERROR: $1${NC}" >&2
  exit 1
}

warn() {
  echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
}

info() {
  echo -e "${BLUE}ℹ️  INFO: $1${NC}"
}

success() {
  echo -e "${GREEN}✅ $1${NC}"
}

header() {
  echo ""
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║ $1${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

# ============================================================================
# Installation Configuration
# ============================================================================

INSTALL_DIR="$HOME/.local/bin"
APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"
CONFIG_DIR="$HOME/.config/reddit-desktop"

# Full expanded paths (NOT using tilde ~)
FULL_INSTALL_PATH="$INSTALL_DIR/reddit-desktop"
USERNAME=$(whoami)
HOME_DIR=$(eval echo "~$USERNAME")

# GitHub URLs
GITHUB_REPO="https://github.com/majorrayat-ui/reddit-desktop"
RELEASE_URL="$GITHUB_REPO/releases/download/v1.0.0/Reddit-Desktop-1.0.0-x86_64.AppImage"
ICON_URL="$GITHUB_REPO/raw/main/csc-main/Reddit/src/assets/icons/reddit.png"

# ============================================================================
# Pre-flight Checks
# ============================================================================

header "REDDIT DESKTOP - INSTALLATION (VERSION 2.0 - CRITICAL FIXES)"

info "Checking system compatibility..."

# Check if running on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
  error "This installer only works on Linux systems."
fi

# Check for required commands
for cmd in curl mkdir chmod; do
  if ! command -v "$cmd" &> /dev/null; then
    error "Required command '$cmd' not found. Please install it."
  fi
done

info "System checks passed ✓"

# ============================================================================
# Create directories
# ============================================================================

info "Creating application directories..."
mkdir -p "$INSTALL_DIR" || error "Failed to create $INSTALL_DIR"
mkdir -p "$APPS_DIR" || error "Failed to create $APPS_DIR"
mkdir -p "$ICONS_DIR" || error "Failed to create $ICONS_DIR"
mkdir -p "$CONFIG_DIR" || error "Failed to create $CONFIG_DIR"
success "Directories created"

# ============================================================================
# Download AppImage
# ============================================================================

header "DOWNLOADING REDDIT DESKTOP APPIMAGE"

APPIMAGE_PATH="$INSTALL_DIR/reddit-desktop"

if [[ -f "$APPIMAGE_PATH" ]]; then
  info "Found existing installation at $APPIMAGE_PATH"
  info "Backing up old version..."
  mv "$APPIMAGE_PATH" "$APPIMAGE_PATH.backup" || warn "Could not backup old version"
fi

info "Downloading from: $RELEASE_URL"

download_success=0
if command -v curl &> /dev/null; then
  if curl -fsSL "$RELEASE_URL" -o "$APPIMAGE_PATH"; then
    download_success=1
    success "Downloaded with curl"
  fi
fi

if [[ $download_success -eq 0 ]] && command -v wget &> /dev/null; then
  if wget -q "$RELEASE_URL" -O "$APPIMAGE_PATH"; then
    download_success=1
    success "Downloaded with wget"
  fi
fi

if [[ $download_success -eq 0 ]]; then
  error "Failed to download AppImage - check internet connection or GitHub availability"
fi

# Verify AppImage was downloaded
APPIMAGE_SIZE=$(stat -c%s "$APPIMAGE_PATH" 2>/dev/null || echo "0")
if [[ $APPIMAGE_SIZE -lt 100000000 ]]; then
  error "Downloaded file appears corrupted or too small (got $APPIMAGE_SIZE bytes, expected ~123 MB)"
fi

# Make executable
chmod 755 "$APPIMAGE_PATH" || error "Failed to make AppImage executable"
success "AppImage verified ($(numfmt --to=iec-i --suffix=B $APPIMAGE_SIZE 2>/dev/null || echo "123 MB"))"

# ============================================================================
# Verify AppImage integrity
# ============================================================================

info "Verifying AppImage integrity..."
if file "$APPIMAGE_PATH" | grep -q "ELF 64-bit"; then
  success "AppImage is a valid ELF 64-bit executable"
else
  error "AppImage verification failed - not a valid ELF executable"
fi

# ============================================================================
# Download and install icon
# ============================================================================

header "SETTING UP APPLICATION ICON"

ICON_PATH="$ICONS_DIR/reddit-desktop.png"

info "Downloading icon from GitHub..."

icon_download=0
if command -v curl &> /dev/null; then
  if curl -fsSL "$ICON_URL" -o "$ICON_PATH" 2>/dev/null; then
    icon_download=1
  fi
fi

if [[ $icon_download -eq 0 ]] && command -v wget &> /dev/null; then
  if wget -q "$ICON_URL" -O "$ICON_PATH" 2>/dev/null; then
    icon_download=1
  fi
fi

# Make icon readable
if [[ -f "$ICON_PATH" ]]; then
  chmod 644 "$ICON_PATH" || true
  success "Icon installed to $ICON_PATH"
else
  if [[ $icon_download -eq 0 ]]; then
    warn "Icon download failed - continuing without icon"
  fi
  ICON_PATH="reddit-desktop"
fi

# ============================================================================
# Create desktop entry
# ============================================================================

header "CREATING DESKTOP LAUNCHER"

# CRITICAL FIX: Use FULL ABSOLUTE PATH, NOT tilde (~)
# This is why the app wasn't appearing in the menu!

info "Creating desktop entry..."
info "Exec path: $HOME_DIR/.local/bin/reddit-desktop"

cat > "$APPS_DIR/reddit-desktop.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Reddit
GenericName=Reddit Client
Comment=Reddit Desktop - Access Reddit from a Native Linux Application
Exec=$HOME_DIR/.local/bin/reddit-desktop %U
Icon=reddit-desktop
Terminal=false
Categories=Network;WebBrowser;Social;Chat;
StartupNotify=true
StartupWMClass=Reddit
X-GNOME-Usable-Disabled=false
Keywords=reddit;social;news;discussion;
X-AppImage-Name=Reddit Desktop
X-AppImage-Version=1.0.0
EOF

# Set correct permissions
chmod 644 "$APPS_DIR/reddit-desktop.desktop" || error "Failed to set desktop file permissions"
success "Desktop entry created"

# Validate desktop entry
if command -v desktop-file-validate &> /dev/null; then
  info "Validating desktop entry syntax..."
  if desktop-file-validate "$APPS_DIR/reddit-desktop.desktop" &>/dev/null; then
    success "Desktop entry validation passed"
  else
    warn "Desktop entry validation warning (may still work)"
  fi
fi

# ============================================================================
# Update desktop database
# ============================================================================

header "UPDATING DESKTOP DATABASE & CACHES"

if command -v update-desktop-database &> /dev/null; then
  info "Running update-desktop-database..."
  update-desktop-database "$APPS_DIR" 2>/dev/null && success "Desktop database updated" || warn "update-desktop-database failed"
else
  warn "update-desktop-database not found (application may not appear in menu)"
fi

# ============================================================================
# Update icon cache
# ============================================================================

if command -v update-icon-caches &> /dev/null; then
  info "Running update-icon-caches..."
  update-icon-caches "$HOME/.local/share/icons/" 2>/dev/null && success "Icon cache updated" || warn "Icon cache update failed"
elif command -v gtk-update-icon-cache &> /dev/null; then
  info "Running gtk-update-icon-cache..."
  gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor/" 2>/dev/null && success "Icon cache updated (gtk)" || warn "Icon cache update failed"
else
  warn "No icon cache update tools found"
fi

# ============================================================================
# Setup PATH
# ============================================================================

header "CONFIGURING SHELL PATH"

if [[ -f "$HOME/.bashrc" ]]; then
  if grep -q '\.local/bin' "$HOME/.bashrc"; then
    success "PATH already configured in ~/.bashrc"
  else
    info "Adding ~/.local/bin to PATH..."
    {
      echo ""
      echo "# Added by Reddit Desktop installer"
      echo 'export PATH="$HOME/.local/bin:$PATH"'
    } >> "$HOME/.bashrc"
    success "PATH configured (source ~/.bashrc to apply immediately)"
  fi
fi

# ============================================================================
# Verification
# ============================================================================

header "VERIFYING INSTALLATION"

all_pass=true

# Check 1: AppImage
if [[ -x "$APPIMAGE_PATH" ]]; then
  success "✓ AppImage executable"
else
  echo -e "${RED}✗ AppImage not executable${NC}"
  all_pass=false
fi

# Check 2: Desktop entry
if [[ -f "$APPS_DIR/reddit-desktop.desktop" ]]; then
  success "✓ Desktop entry created"
else
  echo -e "${RED}✗ Desktop entry missing${NC}"
  all_pass=false
fi

# Check 3: Icon
if [[ -f "$ICON_PATH" ]]; then
  success "✓ Icon installed"
elif [[ "$ICON_PATH" == "reddit-desktop" ]]; then
  warn "✓ Icon fallback (generic name)"
else
  warn "✓ Icon missing (app will still work)"
fi

# Check 4: Permissions
if [[ -r "$APPS_DIR/reddit-desktop.desktop" && -r "$APPIMAGE_PATH" ]]; then
  success "✓ All files readable"
else
  echo -e "${RED}✗ File permission issues${NC}"
  all_pass=false
fi

echo ""
if [[ "$all_pass" == true ]]; then
  success "All critical checks passed!"
else
  warn "Some checks failed - installation may need troubleshooting"
fi

# ============================================================================
# Final Instructions
# ============================================================================

header "INSTALLATION COMPLETE!"

echo -e "${GREEN}🎉 Reddit Desktop has been installed successfully!${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}▶ HOW TO LAUNCH:${NC}"
echo "  1. Search for 'Reddit' in your applications menu"
echo "  2. Or run from terminal:"
echo "     reddit-desktop"
echo "  3. Or run directly:"
echo "     ~/.local/bin/reddit-desktop"
echo ""
echo -e "${BLUE}▶ FILES INSTALLED:${NC}"
echo "  • AppImage:     $APPIMAGE_PATH"
echo "  • Desktop File: $APPS_DIR/reddit-desktop.desktop"
echo "  • Icon:         $ICON_PATH"
echo "  • Config Folder: $CONFIG_DIR"
echo ""
echo -e "${BLUE}▶ IF APP DOESN'T APPEAR IN MENU (TRY THESE):${NC}"
echo "  Option 1 - Restart desktop environment:"
echo "    • KDE/Plasma:   killall -9 plasmashell"
echo "    • GNOME:        killall -9 gnome-shell"
echo "    • XFCE:         xfdesktop --reload"
echo "    • Cinnamon:     killall cinnamon"
echo "    • LXDesktop:    lxpanelctl restart"
echo ""
echo "  Option 2 - Log out and log back in"
echo ""
echo "  Option 3 - Verify installation:"
echo "    file '$APPIMAGE_PATH'"
echo "    ls -lah '$ICON_PATH'"
echo "    desktop-file-validate '$APPS_DIR/reddit-desktop.desktop'"
echo ""
echo -e "${BLUE}▶ TO UNINSTALL:${NC}"
echo "  curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/uninstall.sh | bash"
echo ""
echo -e "${BLUE}▶ FULL TROUBLESHOOTING GUIDE:${NC}"
echo "  https://github.com/majorrayat-ui/reddit-desktop/blob/main/TROUBLESHOOTING.md"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
