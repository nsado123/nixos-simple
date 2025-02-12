#!/bin/bash
# Filename: setupnix.sh

set -e

# Define user for auto-login
AUTOLOGIN_USER="nsado"  # Replace with your actual username

echo "Updating system..."
sudo pacman -Syu --noconfirm

# Step 1: Install Nix Package Manager
echo "Installing Nix..."
sh <(curl -L https://nixos.org/nix/install) --daemon

# Step 2: Enable Nix Daemon
echo "Enabling Nix daemon..."
sudo systemctl enable nix-daemon.service
sudo systemctl start nix-daemon.service

# Step 3: Set Up Environment for Nix
echo "Configuring Nix environment..."
echo 'set -Ux NIX_PATH "$HOME/.nix-defexpr/channels:$NIX_PATH"' >> ~/.config/fish/config.fish
echo 'set -Ux PATH "$HOME/.nix-profile/bin" "$PATH"' >> ~/.config/fish/config.fish

# Step 4: Temporarily Install Home Manager (without permanent config)
echo "Temporarily Installing Home Manager..."
nix run nixpkgs#home-manager -- init --switch
nix run nixpkgs#home-manager -- help  # Ensure it's installed

# Step 5: Set Up Auto TTY Login
echo "Setting up auto-login for TTY..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $AUTOLOGIN_USER --noclear %I $TERM
" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf

echo "Reloading systemd daemon..."
sudo systemctl daemon-reexec
sudo systemctl restart getty@tty1.service

echo "Installation complete! Please reboot your system."
