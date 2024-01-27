{
  description = "My NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    # User Variables
    hostname = "imac27";
    username = "dirk";
    gitUsername = "Dirk Troch";
    gitEmail = "dirk.troch@gicloud.com";
    theLocale = "en_US.UTF-8";
    theKBDLayout = "be";
    theLCVariables = "nl_BE.UTF-8";
    theTimezone = "Europe/Brussels";
    theme = "nord";
    waybarStyle = "style2"; # can be style1-2
    browser = "brave";
    wallpaperGit = "https://gitlab.com/Zaney/my-wallpapers.git";
    wallpaperDir = "/home/${username}/Pictures/Wallpapers";
    flakeDir = "/home/${username}/zaneyos-v2";
    # Driver selection profile
    # Options include amd (tested), intel, nvidia
    # GPU hybrid options: intel-nvidia, amd-nvidia
    # vm for both if you are running a vm
    cpuType = "intel";
    gpuType = "nvidia";
    # Run: sudo lshw -c display to find this info
    # This is needed for hybrid nvidia offloading
    # Run: nvidia-offload (insert program name)
    intel-bus-id = "PCI:0:1:0";
    nvidia-bus-id = "PCI:1:0:0";

    pkgs = import nixpkgs {
      inherit system;
      config = {
	    allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      "${hostname}" = nixpkgs.lib.nixosSystem {
	    specialArgs = { 
          inherit system; inherit inputs; 
          inherit username; inherit hostname;
          inherit gitUsername; inherit theTimezone;
          inherit gitEmail; inherit theLocale;
          inherit wallpaperDir; inherit wallpaperGit;
          inherit cpuType; inherit theKBDLayout;
          inherit theLCVariables; inherit gpuType;
        };
	    modules = [ ./system.nix
          home-manager.nixosModules.home-manager {
	        home-manager.extraSpecialArgs = { inherit username; 
              inherit gitUsername; inherit gitEmail;
              inherit inputs; inherit theme;
              inherit browser; inherit wallpaperDir;
              inherit wallpaperGit; inherit flakeDir;
              inherit gpuType; inherit cpuType;
              inherit waybarStyle;
              inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
            };
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.users.${username} = import ./home.nix;
	      }
	    ];
      };
    };
  };
}
