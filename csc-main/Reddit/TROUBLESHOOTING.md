# 🆘 Reddit Desktop - Troubleshooting Guide

If Reddit Desktop isn't appearing in your application menu after installation, follow this guide.

---

## ✅ Quick Fixes

### 1. **Refresh Desktop Environment** (Usually fixes it!)

**For GNOME/Ubuntu:**
```bash
killall -9 gnome-shell
```

**For KDE/Plasma:**
```bash
killall -9 plasmashell
```

**For XFCE:**
```bash
xfdesktop --reload
```

**For LXDesktop:**
```bash
lxpanelctl restart
```

**For Other Desktops:**
Simply **log out and log back in**.

---

### 2. **Manual Desktop Database Refresh**

```bash
update-desktop-database ~/.local/share/applications/
```

If that doesn't work, try:
```bash
gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor/
```

---

## 📋 Verification Checklist

Run these commands to verify your installation:

### Check if AppImage exists:
```bash
ls -lah ~/.local/bin/reddit-desktop
```
✅ Should show: `-rwxr-xr-x ... reddit-desktop (123M)`

### Check if desktop entry exists:
```bash
ls -lah ~/.local/share/applications/reddit-desktop.desktop
```
✅ Should show: `-rw-r--r-- ... reddit-desktop.desktop`

### Check if icon exists:
```bash
ls -lah ~/.local/share/icons/hicolor/512x512/apps/reddit-desktop.png
```
✅ Should show: `-rw-r--r-- ... reddit-desktop.png (54K)`

### Check desktop entry validity:
```bash
desktop-file-validate ~/.local/share/applications/reddit-desktop.desktop
```
✅ Should produce NO output (means it's valid)

### Check if file can be executed:
```bash
~/.local/bin/reddit-desktop --version
```
✅ May show FUSE error (normal on some systems), but the binary is executable

---

## 🔧 Step-by-Step Troubleshooting

If quick fixes didn't work, follow these steps:

### Step 1: Verify Desktop Entry
```bash
cat ~/.local/share/applications/reddit-desktop.desktop
```

You should see:
```
[Desktop Entry]
Version=1.0
Type=Application
Name=Reddit
GenericName=Reddit Client
Comment=Reddit Desktop - Native Reddit Application for Linux
Exec=/home/YOUR_USERNAME/.local/bin/reddit-desktop %U
Icon=reddit-desktop
Terminal=false
Categories=Network;WebBrowser;Chat;
```

If the `Exec` line shows `~/.local/bin/reddit-desktop` instead of full path, reinstall:
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash
```

### Step 2: Verify Icon File
```bash
file ~/.local/share/icons/hicolor/512x512/apps/reddit-desktop.png
```

Should show: `PNG image data, 2000 x 2000`

If icon is missing, reinstall:
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash
```

### Step 3: Manually Update Caches
```bash
# Update desktop database
update-desktop-database ~/.local/share/applications/

# Update icon cache
update-icon-caches ~/.local/share/icons/
# OR
gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor/

# Refresh desktop
killall -9 plasmashell  # For KDE
# OR
killall -9 gnome-shell  # For GNOME
# OR log out and back in
```

---

## 🎯 Alternative Launch Methods

Even if the app doesn't appear in the menu, you can still launch it:

### Launch from Terminal:
```bash
~/.local/bin/reddit-desktop
```

### Add to PATH (if not already added):
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
reddit-desktop
```

### Launch with Full Path:
```bash
/home/$(whoami)/.local/bin/reddit-desktop
```

---

## 🔴 If Nothing Works

### Complete Reinstall:

**Step 1: Uninstall**
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/uninstall.sh | bash
```

**Step 2: Clean Installation Files**
```bash
rm -rf ~/.local/bin/reddit-desktop
rm -rf ~/.local/share/applications/reddit-desktop.desktop
rm -rf ~/.local/share/icons/hicolor/512x512/apps/reddit-desktop.png
rm -rf ~/.config/Reddit
```

**Step 3: Clear Caches**
```bash
rm -rf ~/.cache/
```

**Step 4: Reinstall**
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash
```

**Step 5: Refresh Desktop**
```bash
# KDE
killall -9 plasmashell

# GNOME
killall -9 gnome-shell

# Others: Log out and back in
```

---

## 🖥️ Desktop Environment Specific Issues

### **GNOME / Ubuntu**
- If still not showing: Click "Activities" → Search for "Reddit"
- Or: Open Activities → Search "Show Applications" → Scroll to find Reddit
- Try: `sudo update-desktop-database -r`

### **KDE / Plasma**
- Restart: `kquitapp5 plasmashell && kstart5 plasmashell &`
- Or: `killall -9 plasmashell` then restart

### **XFCE**
- Right-click panel → Panel Preferences → Items tab → Application Menu (refresh)
- Or: `xfce4-appfinder` and search for Reddit

### **LXDesktop**
- `lxpanelctl restart`
- Or log out and back in

---

## 📊 System Requirements Check

Verify your system meets requirements:

```bash
echo "=== System Info ==="
uname -m               # Should show: x86_64
uname -s               # Should show: Linux

echo "=== Required Commands ==="
which curl             # Should show path to curl
which update-desktop-database
which gtk-update-icon-cache

echo "=== Home Directory ==="
echo $HOME             # Should show your home directory path

echo "=== Local directories ==="
ls ~/.local/bin/
ls ~/.local/share/applications/
ls ~/.local/share/icons/hicolor/512x512/apps/
```

---

## 🔗 File Locations

All files should be in these exact locations:

| File | Location | Permissions |
|------|----------|-------------|
| AppImage | `~/.local/bin/reddit-desktop` | 755 |
| Desktop Entry | `~/.local/share/applications/reddit-desktop.desktop` | 644 |
| Icon | `~/.local/share/icons/hicolor/512x512/apps/reddit-desktop.png` | 644 |
| Config (optional) | `~/.config/Reddit/` | User-owned |

---

## ❓ Frequently Asked Questions

### Q: Why doesn't the app show up in the start menu?
**A:** It's usually a cache issue. Try refreshing the desktop environment (see above).

### Q: I see a FUSE error when launching - is this bad?
**A:** No, this just means your system doesn't have FUSE 2 installed. The app still works. Install FUSE:
```bash
# Ubuntu/Debian
sudo apt install libfuse2

# Fedora
sudo dnf install fuse

# Arch
sudo pacman -S fuse2
```

### Q: Can I use the Debian package instead of AppImage?
**A:** Yes! Download from the release page:
```bash
wget https://github.com/majorrayat-ui/reddit-desktop/releases/download/v1.0.0/reddit-desktop_1.0.0_amd64.deb
sudo apt install ./reddit-desktop_1.0.0_amd64.deb
```

### Q: The app launches but Reddit doesn't load - what's wrong?
**A:** Check your internet connection. Try:
```bash
# Test internet
ping reddit.com

# Launch with debug output
~/.local/bin/reddit-desktop --enable-logging
```

### Q: How do I completely remove Reddit Desktop?
**A:** Run:
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/uninstall.sh | bash
```

---

## 📞 Still Having Issues?

If none of these solutions work:

1. **Check the logs:**
   ```bash
   ~/.local/bin/reddit-desktop 2>&1 | tee ~/reddit-desktop.log
   ```

2. **Report on GitHub:**
   - Go to: https://github.com/majorrayat-ui/reddit-desktop/issues
   - Include:
     - Your Linux distribution (Ubuntu, Debian, Fedora, etc.)
     - Desktop environment (GNOME, KDE, XFCE, etc.)
     - Output from verification commands above
     - Any error messages

3. **Manual Verification:**
   ```bash
   echo "Desktop Entry:" && cat ~/.local/share/applications/reddit-desktop.desktop
   echo "" && echo "AppImage:" && file ~/.local/bin/reddit-desktop
   echo "" && echo "Icon:" && file ~/.local/share/icons/hicolor/512x512/apps/reddit-desktop.png
   ```

---

## ✨ Success Indicators

You'll know installation is successful when:

✅ `reddit-desktop` command works in terminal  
✅ Desktop entry file has full paths (not ~)  
✅ Icon file exists and is a valid PNG  
✅ `desktop-file-validate` produces no output  
✅ App appears when you search "Reddit" in app menu  
✅ Clicking the icon launches the application  
✅ Reddit website loads in the application window  

---

**Last Updated**: August 18, 2024  
**Status**: 🟢 Production Ready  
**Version**: 1.0.0
