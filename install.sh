#!/bin/bash

# --- CONFIGURATION & COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define target directories
INSTALL_DIR="$HOME/.config/AquaUI"
QS_DIR="$INSTALL_DIR/Quickshell"
HYPR_DIR="$INSTALL_DIR/Hyprland"
CURRENT_DIR=$(pwd)

echo -e "${BLUE}>>> STARTING AQUA UI DEPLOYMENT...${NC}"

# 1. PRE-FLIGHT CHECKS
# Ensure the script is NOT run as root (AUR helpers fail as root)
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Error: Please do not run this script as root (sudo).${NC}"
  echo "The script will ask for sudo permissions when necessary."
  exit 1
fi

# Check for AUR helper (yay or paru)
if command -v yay &> /dev/null; then 
    AUR="yay"
elif command -v paru &> /dev/null; then 
    AUR="paru"
else
    echo -e "${RED}Error: AUR helper (yay or paru) not found.${NC}"
    exit 1
fi

# 2. PACKAGE INSTALLATION
echo -e "${BLUE}>>> [1/5] Installing system packages...${NC}"

# Official Repositories
# Installing Hyprland, Qt6 dependencies, utilities for scripts (jq, socat), and SDDM
sudo pacman -S --needed --noconfirm \
    socat jq bc brightnessctl grim slurp wireplumber \
    qt6-wayland qt6-svg qt6-declarative qt6-5compat \
    papirus-icon-theme ttf-jetbrains-mono-nerd \
    hyprland wl-clipboard polkit-kde-agent \
    ttf-inter adobe-source-sans-fonts unzip \
    sddm qt6ct

echo -e "${BLUE}>>> Installing AUR packages (Quickshell & Themes)...${NC}"
# whitesur-icon-theme-git: macOS-like icons
# sddm-sugar-candy-git: Modern Login Screen theme
# quickshell-git: The engine for our UI
$AUR -S --needed --noconfirm quickshell-git sddm-sugar-candy-git whitesur-icon-theme-git

# 3. FILE DEPLOYMENT
echo -e "${BLUE}>>> [2/5] Deploying files to $INSTALL_DIR...${NC}"

# Create directory structure
mkdir -p "$QS_DIR"
mkdir -p "$HYPR_DIR"
mkdir -p "$QS_DIR/assets/icons"
mkdir -p "$QS_DIR/assets/backgrounds"

# Copy source code from current directory to target
echo "Copying source files..."
cp -r "$CURRENT_DIR/src" "$QS_DIR/"
cp -r "$CURRENT_DIR/scripts" "$QS_DIR/"
cp "$CURRENT_DIR/shell.qml" "$QS_DIR/"
# Copy qmldir if it exists
cp "$CURRENT_DIR/qmldir" "$QS_DIR/" 2>/dev/null || true

# Copy Hyprland config
if [ -f "$CURRENT_DIR/hyprland.conf" ]; then
    cp "$CURRENT_DIR/hyprland.conf" "$HYPR_DIR/"
else
    echo -e "${RED}Warning: hyprland.conf not found in current directory! Creating a blank one.${NC}"
    touch "$HYPR_DIR/hyprland.conf"
fi

# 4. ASSET DOWNLOAD
echo -e "${BLUE}>>> [3/5] Downloading assets (Wallpapers & Logos)...${NC}"

# Download Apple Logo (White) for the top bar
if [ ! -f "$QS_DIR/assets/icons/apple.svg" ]; then
    curl -sL "https://upload.wikimedia.org/wikipedia/commons/3/31/Apple_logo_white.svg" -o "$QS_DIR/assets/icons/apple.svg"
fi

# Download macOS Big Sur Wallpaper
if [ ! -f "$QS_DIR/assets/backgrounds/wallpaper.jpg" ]; then
    curl -sL "https://raw.githubusercontent.com/xiaoda-gh/macOS-Big-Sur-Wallpapers/main/2560x1440/macOS-Big-Sur-Daylight-Wallpaper-2560x1440.jpg" -o "$QS_DIR/assets/backgrounds/wallpaper.jpg"
fi

# 5. CONFIGURATION PATCHING
echo -e "${BLUE}>>> [4/5] Updating configuration paths...${NC}"

# Make scripts executable
chmod +x "$QS_DIR/scripts/"*.sh

# Update hyprland.conf paths to point to the new location
# 1. Update Quickshell startup command
sed -i "s|cd .* && quickshell|cd $QS_DIR \&\& quickshell|g" "$HYPR_DIR/hyprland.conf"
# 2. Update script paths (replaces ~/aqua-shell placeholders)
sed -i "s|~/aqua-shell|$QS_DIR|g" "$HYPR_DIR/hyprland.conf"
# 3. Remove hyprpaper (since Quickshell handles wallpapers now)
sed -i "/exec-once = hyprpaper/d" "$HYPR_DIR/hyprland.conf"

# Update QML files if they contain hardcoded paths to scripts
# (Searches for old path structure and replaces it with the installed path)
find "$QS_DIR/src" -name "*.qml" -exec sed -i "s|\$HOME/.config/AquaUI/Quickshell|$QS_DIR|g" {} +

# 6. SDDM SETUP (Login Screen)
echo -e "${BLUE}>>> [5/5] Configuring SDDM (Login Screen)...${NC}"

# Create SDDM config to use the Sugar Candy theme
sudo mkdir -p /etc/sddm.conf.d
echo "[Theme]
Current=sugar-candy
" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null

# Enable the display manager service
echo "Enabling sddm.service..."
sudo systemctl enable sddm

# 7. COMPLETION
echo -e "${GREEN}>>> INSTALLATION COMPLETE!${NC}"
echo -e "-----------------------------------------------------"
echo -e "Files installed to: $INSTALL_DIR"
echo -e "Hyprland Config:    $HYPR_DIR/hyprland.conf"
echo -e "-----------------------------------------------------"
echo -e "Please REBOOT your system now."
echo -e "Select 'Hyprland' session at the login screen."
echo -e "-----------------------------------------------------"