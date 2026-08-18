#!/bin/bash
# Post-removal script for Reddit Desktop

# Update desktop database if available
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database ~/.local/share/applications/ || true
fi

# Update icon cache if available
if command -v update-icon-caches &> /dev/null; then
    update-icon-caches ~/.local/share/icons/ || true
fi

exit 0
