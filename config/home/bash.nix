{ config, pkgs, flakeDir, ... }:

{
  # Configure Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #  exec Hyprland
      #fi
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
    '';
    initExtra = ''
      neofetch
    '';
    sessionVariables = {
    
    };
    shellAliases = {
      sv="sudo vim";
      flake-rebuild="sudo nixos-rebuild switch --flake ${flakeDir}";
      flake-update="sudo nix flake update ${flakeDir}";
      gcCleanup="nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v="vim";
      ls="lsd";
      ll="lsd -l";
      la="lsd -a";
      lal="lsd -al";
      ".."="cd ..";
    };
  };
}
