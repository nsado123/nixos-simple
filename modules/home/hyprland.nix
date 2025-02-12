{ config, pkgs, lib, ... }:

let
  # Define commonly used packages
  home.packages = with pkgs; [
    
    # Hyprland
    hyprland
    hyprpolkitagent
    # Screenshots
    grimblast
    slurp
    # Clipboard
    wl-clipboard
    cliphist
    # Portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    # UWSM
    uwsm
  ];
in

{
  # Transfer Configs
  home.file = {
    # UWSM
    ".config/uwsm" = {
      source = ../../sources/uwsm;
      recursive = true;
      forced = true;
    };

    # Hyprland
    ".config/hypr" = {
      source = ../../sources/hyprland;
      recursive = true;
      forced = true;
    };

    # Swaync
    ".config/swaync" = {
      source = ../../sources/swaync;
      recursive = true;
      forced = true;
    };

    # Swayosd
    ".config/swayosd" = {
      source = ../../sources/swayosd;
      recursive = true;
      forced = true;
    };

    # Wlogout
    ".config/wlogout" = {
      source = ../../sources/wlogout;
      recursive = true;
      forced = true;
    };
    
    # Rofi
    ".config/rofi" = {
      source = ../../sources/rofi;
      recursive = true;
      forced = true;
    };

    # Waybar
    ".config/waybar" = {
      source = ../../sources/waybar;
      recursive = true;
      forced = true;
    };
  };

  # Hyprlock
  programs.hyprlock.enable = true;
  # Hypridle
  services.hypridle.enable = true;
  # Hyprpaper
  services.hyprpaper.enable = true;
  # Swaync
  services.swaync.enable = true;
  # Swayosd
  services.swayosd.enable = true;
  # Wlogout
  programs.wlogout.enable = true;
  # Rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland-unwrapped;
  };
  # Waybar
  programs.waybar = {
    enable = true;
    systemd.enable = true;  
  };

}