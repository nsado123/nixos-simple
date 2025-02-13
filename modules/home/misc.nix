{ config, pkgs, stablepkgs, ... }:

let
  # Vivaldi
  vivaldilst = [
    (pkgs.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = false;
    })
  ];

  # Dolphin
  dolphinlst = with pkgs; [
    kdePackages.dolphin
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse    
    kdePackages.qtsvg         
    kdePackages.qtwayland     
    kdePackages.ark
    kdePackages.kde-cli-tools
    libsForQt5.qt5.qtimageformats
    kdePackages.ffmpegthumbs
  ];

  # Spotify
  spotifylst = [
    (pkgs.spotify.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/spotify \
          --set=OZONE_PLATFORM=wayland \
          --add-flags="--ozone-platform=wayland"
      '';
    }))
  ];

in

{
  # Packages
  home.packages = dolphinlst ++ vivaldilst ++ spotifylst;

  # VSCode
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    userSettings = {
      "workbench.startupEditor" = "none";
      "telemetry.enableTelemetry" = "off";
      #"workbench.colorTheme" = "Dark Modern";
      # Add other settings as needed...
    };

    extensions = [
      # C/C++ extensions
      pkgs.vscode-extensions.ms-vscode.cpptools
      pkgs.vscode-extensions.ms-vscode.cpptools-extension-pack
      # Rust
      pkgs.vscode-extensions.rust-lang.rust-analyzer
      stablepkgs.vscode-extensions.vadimcn.vscode-lldb
      pkgs.vscode-extensions.fill-labs.dependi
      # Github
      pkgs.vscode-extensions.github.copilot
      pkgs.vscode-extensions.github.vscode-pull-request-github
      # Nix
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.jnoortheen.nix-ide
      # Python
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.ms-python.debugpy
      # CSV
      pkgs.vscode-extensions.mechatroner.rainbow-csv
      # Add other extensions as needed
    ];
  };
}
