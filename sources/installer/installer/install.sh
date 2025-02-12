#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Helper function for printing status messages
function print_status() {
    echo -e "${GREEN}$1${NC}"
}

# Helper function to check if a command is installed
function is_installed() {
    command -v "$1" &>/dev/null
}

# Step 1: Check if the system is Arch-based
print_status "Checking if the system is Arch-based..."
if ! grep -q 'ID_LIKE=.*arch' /etc/os-release; then
    echo -e "${RED}This script only works on Arch-based distributions.${NC}"
    exit 1
fi
print_status "System confirmed as Arch-based."

# Step 2: Check if an AUR helper is installed (yay or paru)
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo "No AUR helper found."
    echo "Choose an AUR helper to install:"
    select aur_helper in "paru" "yay"; do
        case $aur_helper in
            paru) 
                echo "Installing paru..."
                sudo pacman -Sy paru
                break
                ;;
            yay)
                echo "Installing yay..."
                sudo pacman -Sy yay
                break
                ;;
            *) 
                echo "Invalid choice, please select 1 or 2."
                ;;
        esac
    done
fi

print_status "Using AUR helper: $aur_helper"

# Step 3: Install packages from pacman-pkg.lst
if [ -f pacman-pkg.lst ]; then
    echo "Installing packages from pacman-pkg.lst..."
    sudo pacman -Syu - < pacman-pkg.lst
else
    echo "Error: pacman-pkg.lst is missing. Please create the file to continue."
    exit 1
fi

# Step 4: Check if rustup is installed, if not install rustup
if command -v rustup &>/dev/null; then
    print_status "rustup found. Setting default toolchain to stable..."
    rustup default stable
    print_status "rustup default stable set successfully."
else
    print_status "rustup not found. Installing rustup..."
    # Install rustup if not found
    sudo pacman -S rustup --noconfirm
    # After installing rustup, set the default toolchain to stable
    rustup default stable
    print_status "rustup installed and default toolchain set to stable."
fi

# Step 5: Check if Rust is installed (if rustup wasn't present)
if ! command -v rustc &>/dev/null; then
    print_status "Rust not found. Installing Rust..."
    sudo pacman -S --needed rust
    print_status "Rust installed successfully."
else
    print_status "Rust is already installed."
fi

# Step 6: Install packages from aur-pkg.lst using the selected AUR helper
if [ -f aur-pkg.lst ]; then
    echo "Installing packages from aur-pkg.lst..."
    if [[ "$aur_helper" == "paru" ]]; then
        paru -S - < aur-pkg.lst
    elif [[ "$aur_helper" == "yay" ]]; then
        yay -S - < aur-pkg.lst
    else
        echo "No valid AUR helper found."
    fi
else
    echo "aur-pkg.lst not found!"
fi

# Step 7: Ask for Flatpak installation
read -p "Do you want to install Flatpak? (y/n): " install_flatpak
if [[ "$install_flatpak" =~ ^[Yy]$ ]]; then
    if ! is_installed "flatpak"; then
        echo "Installing Flatpak..."
        sudo pacman -Sy flatpak
    else
        echo "Flatpak is already installed."
    fi

    # Step 8: Install Flatpak packages from flatpak-pkg.lst
    if [ -f flatpak-pkg.lst ]; then
        echo "Installing Flatpak packages from flatpak-pkg.lst..."
        while read -r package; do
            flatpak install -y "$package"
        done < flatpak-pkg.lst
    else
        echo "flatpak-pkg.lst not found!"
    fi
else
    echo "Flatpak installation skipped."
fi

# Step 9: Enable and start system services from system.lst
if [ -f system.lst ]; then
    echo "Enabling and starting system services from system.lst..."
    while read -r service; do
        sudo systemctl enable --now "$service"
    done < system.lst
else
    echo "system.lst not found!"
fi

# Step 10: Enable and start user services from user.lst
if [ -f user.lst ]; then
    echo "Enabling and starting user services from user.lst..."
    while read -r service; do
        systemctl --user enable --now "$service"
    done < user.lst
else
    echo "user.lst not found!"
fi

# Step 11: Reboot the system
read -p "Do you want to reboot now? (y/n): " reboot_now
if [[ "$reboot_now" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installation complete. Rebooting the system...${NC}"
    sudo reboot
else
    echo "Reboot skipped."
fi

