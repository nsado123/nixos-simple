{ pkgs, inputs, lib, nurpkgs, ... }:

let
  pkgslst = with pkgs; [
    nano
    rsync
    brightnessctl
    kdePackages.kwallet
    kdePackages.kwallet-pam
    rustup
    libnotify
    imagemagick
    parallel
    cmake
    jq
    kdePackages.ffmpegthumbs
    udiskie
    bluez
    bluez-tools
    networkmanager
    networkmanagerapplet
    nextcloud-client
    btop
    stow
    flatpak
    pamixer
    pavucontrol
    wireplumber
    pipewire
    obsidian
    discord
    waytrogen
    mesa
  ];
in

{
  # Combined Package List
  home.packages = pkgslst;

  # Import Modules
  imports = [
    ./home/hyprland.nix
    ./home/terminal.nix
    ./home/misc.nix
    ./home/theme.nix
  ];

  home.file = {
    # Scripts
    ".config/scripts" = {
      source = .././sources/scripts;
      recursive = true;
      force = true;
    };
  };
}
