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

echo -e "${BLUE}>>> STARTING AQUA UI DEPLOYMENT (w/ Kitty)...${NC}"

# 1. PRE-FLIGHT CHECKS
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Error: Please do not run this script as root (sudo).${NC}"
  exit 1
fi

if command -v yay &> /dev/null; then AUR="yay"; elif command -v paru &> /dev/null; then AUR="paru"; else
    echo -e "${RED}Error: AUR helper (yay or paru) not found.${NC}"; exit 1
fi

# 2. PACKAGE INSTALLATION
echo -e "${BLUE}>>> [1/6] Installing system packages...${NC}"

# Added 'kitty' to the list
sudo pacman -S --needed --noconfirm \
    socat jq bc brightnessctl grim slurp wireplumber \
    qt6-wayland qt6-svg qt6-declarative qt6-5compat \
    papirus-icon-theme ttf-jetbrains-mono-nerd \
    hyprland wl-clipboard polkit-kde-agent \
    ttf-inter adobe-source-sans-fonts unzip \
    sddm qt6ct kitty

echo -e "${BLUE}>>> Installing AUR packages...${NC}"
$AUR -S --needed --noconfirm quickshell-git sddm-sugar-candy-git whitesur-icon-theme-git

# 3. FILE DEPLOYMENT
echo -e "${BLUE}>>> [2/6] Deploying files to $INSTALL_DIR...${NC}"

mkdir -p "$QS_DIR"
mkdir -p "$HYPR_DIR"
mkdir -p "$QS_DIR/assets/icons"
mkdir -p "$QS_DIR/assets/backgrounds"

echo "Copying source files..."
cp -r "$CURRENT_DIR/src" "$QS_DIR/"
cp -r "$CURRENT_DIR/scripts" "$QS_DIR/"
cp "$CURRENT_DIR/shell.qml" "$QS_DIR/"
cp "$CURRENT_DIR/qmldir" "$QS_DIR/" 2>/dev/null || true

if [ -f "$CURRENT_DIR/hyprland.conf" ]; then
    cp "$CURRENT_DIR/hyprland.conf" "$HYPR_DIR/"
else
    echo -e "${RED}Warning: hyprland.conf not found! Creating a blank one.${NC}"
    touch "$HYPR_DIR/hyprland.conf"
fi

# 4. ASSET DOWNLOAD
echo -e "${BLUE}>>> [3/6] Downloading assets...${NC}"

if [ ! -f "$QS_DIR/assets/icons/apple.svg" ]; then
    curl -sL "https://upload.wikimedia.org/wikipedia/commons/3/31/Apple_logo_white.svg" -o "$QS_DIR/assets/icons/apple.svg"
fi

if [ ! -f "$QS_DIR/assets/backgrounds/wallpaper.jpg" ]; then
    curl -sL "https://raw.githubusercontent.com/xiaoda-gh/macOS-Big-Sur-Wallpapers/main/2560x1440/macOS-Big-Sur-Daylight-Wallpaper-2560x1440.jpg" -o "$QS_DIR/assets/backgrounds/wallpaper.jpg"
fi

# 5. KITTY CONFIGURATION (New Step)
echo -e "${BLUE}>>> [4/6] Configuring Kitty Terminal...${NC}"
mkdir -p "$HOME/.config/kitty"

# Generating a style-consistent config
cat <<EOF > "$HOME/.config/kitty/kitty.conf"
# AquaUI Kitty Configuration

# Fonts
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        12.0

# Window
window_padding_width 15
hide_window_decorations yes
confirm_os_window_close 0

# Background (Transparent for Hyprland Blur)
background_opacity 0.7
dynamic_background_opacity yes

# Colors (Tokyo Night inspired, matches dark UI)
foreground #a9b1d6
background #1a1b26
selection_foreground #c0caf5
selection_background #33467c
url_color #73daca
cursor #c0caf5

# Tabs
tab_bar_style powerline
tab_powerline_style slanted

# Shell
shell .
editor nano
EOF

# 6. CONFIGURATION PATCHING
echo -e "${BLUE}>>> [5/6] Updating configuration paths...${NC}"

chmod +x "$QS_DIR/scripts/"*.sh

# Patch Hyprland config
sed -i "s|cd .* && quickshell|cd $QS_DIR \&\& quickshell|g" "$HYPR_DIR/hyprland.conf"
sed -i "s|~/aqua-shell|$QS_DIR|g" "$HYPR_DIR/hyprland.conf"
sed -i "/exec-once = hyprpaper/d" "$HYPR_DIR/hyprland.conf"

# Ensure default terminal is set to kitty in hyprland.conf (just in case)
# This replaces any "$terminal = ..." line with "$terminal = kitty"
sed -i 's/^\$terminal = .*/$terminal = kitty/' "$HYPR_DIR/hyprland.conf"

# Patch QML files
find "$QS_DIR/src" -name "*.qml" -exec sed -i "s|\$HOME/.config/AquaUI/Quickshell|$QS_DIR|g" {} +

# 7. SDDM SETUP
echo -e "${BLUE}>>> [6/6] Configuring SDDM...${NC}"

sudo mkdir -p /etc/sddm.conf.d
echo "[Theme]
Current=sugar-candy
" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null

echo "Enabling sddm.service..."
sudo systemctl enable sddm

echo -e "${GREEN}>>> INSTALLATION COMPLETE!${NC}"
echo -e "-----------------------------------------------------"
echo -e "Terminal set to: Kitty (Configured)"
echo -e "Hyprland Config: $HYPR_DIR/hyprland.conf"
echo -e "-----------------------------------------------------"
echo -e "Please REBOOT your system."