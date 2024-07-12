{
    description = "My flakes configuration";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/master";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
        home-manager-stable = { url = "github:nix-community/home-manager/release-24.05"; inputs.nixpkgs.follows = "nixpkgs-stable"; };
        sops-nix = { url = "github:Mic92/sops-nix/yubikey-support"; inputs.nixpkgs.follows = "nixpkgs";  };
        disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
        stylix = { url = "github:danth/stylix"; inputs = { nixpkgs.follows = "nixpkgs"; home-manager.follows = "home-manager"; }; };
        hyprland.url = "github:hyprwm/Hyprland";
        hyprland-plugins = { url = "github:hyprwm/hyprland-plugins"; inputs.hyprland.follows = "hyprland"; };
    };

    outputs = { self, nixpkgs, nixpkgs-stable, home-manager, home-manager-stable, nixos-hardware, sops-nix, stylix, ... }@inputs:
    let
        system = "x86_64-linux";
        specialArgs =  inputs // { inherit system nixos-hardware; };

        shared-modules = [
            sops-nix.nixosModules.sops
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager {
                home-manager = {
                    useUserPackages = true;
                    extraSpecialArgs = specialArgs;
                    sharedModules = [
                        sops-nix.homeManagerModules.sops
                    ];
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
    in {
        nixosConfigurations = {
            verdandi = nixpkgs.lib.nixosSystem {
                inherit specialArgs system pkgs;
                modules = shared-modules ++ [ ./hosts/verdandi.nix ];
            };
            badb = nixpkgs.lib.nixosSystem {
                inherit specialArgs system pkgs;
                modules = shared-modules ++ [ ./hosts/badb.nix ];
            };
            octopi = nixpkgs.lib.nixosSystem {
                inherit specialArgs pkgs;
                system = "aarch64-linux";
                modules = shared-modules ++ [ ./hosts/octopi.nix ];
            };
        };
    };
}
