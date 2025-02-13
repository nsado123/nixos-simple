{ config, pkgs, ... }:

{

  # Transfers Files
  home.file = {
    # Fastfetch
    ".config/fastfetch" = {
      source = ../../sources/fastfetch;
      recursive = true;
      force = true;
    };
    # Kitty
    ".config/kitty" = {
      source = ../../sources/kitty;
      recursive = true;
      force = true;
    };
    # Fish
    #".config/fish" = {
    #  source = ../../sources/fish;
    #  recursive = true;
    #  force = true;
    #}
  };

  # Git
  programs.git = {
    enable = true;
    userName = "nsado123";
    userEmail = "aydenbaghdoian@gmail.com";
  };

  # Fish Shell
  programs.fish = {
    enable = true;

    # Aliases
    shellAliases = {
      l  = "eza -lh --icons=auto";
      ls = "eza -1 --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ld = "eza -lhD --icons=auto";
      lt = "eza --icons=auto --tree";
      cc = "clear";
      ff = "clear && fastfetch";
      fix-pass = "faillock --user nsado --reset";   
    };

    # Config.Fish
    interactiveShellInit = ''
      set fish_greeting # Disable Greeting
      # Nix
      set -Ux NIX_PATH "$HOME/.nix-defexpr/channels:$NIX_PATH"
      set -Ux PATH "$HOME/.nix-profile/bin" "$PATH"
      # Yazi
      function y
      	set tmp (mktemp -t "yazi-cwd.XXXXXX")
      	yazi $argv --cwd-file="$tmp"
      	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      		builtin cd -- "$cwd"
      	end
      	rm -f -- "$tmp"
      end
      fastfetch # Start Fastfetch
      # TTY Login
      if status --is-login
        if test (tty) = /dev/tty1
          exec uwsm start -- hyprland.desktop
        end
      end
    '';
    
    # Abbreviations
    shellAbbrs = {
      ".."  = "z ..";
      "..." = "z ../..";
      ".3"  = "z ../../..";
      ".4"  = "z ../../../..";
      ".5"  = "z ../../../../..";
      mkdir = "mkdir -p";
    };
  };

  # FastFetch
  programs.fastfetch.enable = true;

  # Kitty
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
  };

  # Starship Prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Yazi
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  # Eza
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
  };

}
