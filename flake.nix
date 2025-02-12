{
  description = "Simple Nsado's Flakes";

  inputs = {
  # Basic Nix Repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";  
  # Stable Nix Repos
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
  # NUR Community Repos
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  # Home Manager Inputs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  # Stylix Inputs
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nur, home-manager, stylix, ... }@inputs:

  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    stablepkgs = nixpkgs-stable.legacyPackages.${system};
    nurpkgs = nur.legacyPackages.${system};
  in

  {
    # Nixos System Configuration (ignore for now)
    # Home Manager Configuration
    homeConfigurations = {
      "laptop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/laptop/home
          stylix.homeManagerModules.stylix
        ];
        extraSpecialArgs = {inherit inputs stablepkgs nurpkgs;};
      };
      "desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/desktop/home.nix
          stylix.homeManagerModules.stylix
        ];
        extraSpecialArgs = {inherit inputs stablepkgs nurpkgs;};
      };
    };
  };
}
