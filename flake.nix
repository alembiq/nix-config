{
  description = "My flakes configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # master
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixpkgs-wayland = {
        url = "github:nix-community/nixpkgs-wayland";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix/yubikey-support";
    };
    wezterm = {
      url = "github:wez/wezterm/?dir=nix";
    };
    disko = {
      url = "github:nix-community/disko";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    #hyprland.url = "github:hyprwm/Hyprland";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      ...
    }:
    let
      system = "x86_64-linux";
      specialArgs = inputs // {
        inherit system pkgs-stable;
      };
      shared-modules = [
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
        inputs.disko.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.hyprpanel.overlay
            inputs.nixpkgs-wayland.overlay
        ];
          _module.args = {
            inherit inputs;
          };
          home-manager = {
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
          };
        }
      ];
      pkgs = import nixpkgs {
        system = system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      pkgs-stable = import nixpkgs-stable {
        system = system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        verdandi = nixpkgs.lib.nixosSystem {
          inherit specialArgs pkgs;
          system = "x86_64-linux";
          modules = shared-modules ++ [ ./hosts/verdandi ];
        };
        badb = nixpkgs.lib.nixosSystem {
          # change to nixpkgs-stable
          inherit specialArgs pkgs; # change to pkgs-stable
          system = "x86_64-linux";
          modules = shared-modules ++ [ ./hosts/badb ];
        };
        octopi = nixpkgs.lib.nixosSystem {
          inherit specialArgs pkgs;
          system = "aarch64-linux";
          modules = shared-modules ++ [ ./hosts/octopi ];
        };
      };
    };
}
