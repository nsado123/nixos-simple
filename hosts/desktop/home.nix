{ config, pkgs, ... }:

{
  # Let Home-Manager Install and Manage Itself
  programs.home-manager.enable = true;

  # Activating Flakes
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  # Information About the User
  home.username = "nsado";
  home.homeDirectory = "/home/nsado";

  # Version
  home.stateVersion = "24.11";

  # Nix Fix (Install Nix for Home Manager)
  nix.package = pkgs.nix;

  # Modules to Import
  imports = [
    # General Modules
    ../../modules/common.nix
  ];

  # Stow Configs
  home.file = {
    ".config/" = {
      source = ../../sources/misc;
      recursive = true;
      forced = true;
    };

    ".config/scripts" = {
      source = ../../sources/scripts;
      recursive = true;
      forced = true;
    };
    
  };

}
