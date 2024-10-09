{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # inputs.disko.nixosModules.default
    ../default.nix
    ../default-workstation.nix
    # ../modules/nixos/remotebuilder.nix
    ../../users/charles.nix
    ../../users/backup.nix
    ./badb-disko.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/stylix.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  home-manager = {
    users.charles = {

      imports = [
        ../../modules/homemanager/mail.nix
        ../../modules/homemanager/waybar.nix
        # ../modules/homemanager/hyprland.nix
        # ../modules/homemanager/hyprlock.nix
        # ../modules/homemanager/hypridle.nix
        ../../modules/homemanager/wezterm.nix
        ../../modules/homemanager/firefox.nix
        ../../modules/homemanager/nextcloud.nix
        # ../modules/homemanager/photography.nix
        ../../modules/homemanager/vscodium.nix
        ../../modules/homemanager/sway.nix
        ../../modules/homemanager/wofi.nix
      ];

      home = {
        packages = with pkgs; [
          poppler_utils # pdf tools
        ];
        stateVersion = "23.11";
      }; # END of home-manager.users.charles.home
    }; # END of home-manager.users.charles
  }; # END of home-manager

  services = {
    # zram-generator = {
    #     enable = true;
    #     settings.zram0 = {
    #         compression-algorithm = "zstd";
    #         zram-size = "ram * 2";
    #     };
    # };
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    system76-scheduler.settings.cfsProfiles.enable = true;
    power-profiles-daemon.enable = false; # needed to enable TLP
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 50;

        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };
    sanoid = {
      enable = true;
      interval = "*:2,32";
      templates.backup = {
        hourly = 36;
        daily = 14;
        weekly = 0;
        monthly = 0;
        yearly = 0;
        autoprune = true;
        autosnap = true;
      };
      templates.day = {
        hourly = 0;
        daily = 7;
        weekly = 0;
        monthly = 0;
        yearly = 0;
        autoprune = true;
        autosnap = true;
      };
      templates.rotate = {
        autoprune = true;
        autosnap = true;
        hourly = 1;
        daily = 1;
        weekly = 1;
        monthly = 0;
        yearly = 0;
      };
      datasets."zpool/home/charles" = {
        useTemplate = [ "backup" ];
      };
      datasets."zpool/nixos/etc" = {
        useTemplate = [ "backup" ];
      };
      datasets."zpool/nixos" = {
        useTemplate = [ "day" ];
      };
      datasets."zpool/home/charles/mail" = {
        useTemplate = [ "rotate" ];
      };
      datasets."zpool/home/charles/cache" = {
        useTemplate = [ "rotate" ];
      };
      datasets."zpool/home/charles/torrent" = {
        useTemplate = [ "rotate" ];
      };
      datasets."zpool/home/charles/audio" = {
        useTemplate = [ "rotate" ];
      };
      datasets."zpool/home/charles/documents" = {
        useTemplate = [ "rotate" ];
      };
      datasets."zpool/home/charles/games" = {
        useTemplate = [ "rotate" ];
      };
      datasets."zpool/home/charles/pictures" = {
        useTemplate = [ "rotate" ];
      };

    };
    syncoid = {
      # FIXME do pull insted of push
      user = "backup";
      enable = true;
      interval = "*:35";
      commonArgs = [
        "--no-sync-snap"
        "--debug"
      ];
      # commands = {
      #     "nixos" = {
      #         source = "zpool/nixos/etc";
      #         target = "backup@100.118.57.39:tank/vault/localhost-verdandi/20240325_nixos";
      #         sendOptions = "w c";
      #         #TODO syncoid path and the key /var/lib/syncoid/id_ed25519 ? user backup
      #         sshKey = "/var/lib/syncoid/id_ed25519";
      #         extraArgs = [ "--sshoption=StrictHostKeyChecking=off" "--recursive" ];
      #     };
      #     "home" = {
      #         source = "zpool/home/charles";
      #         target = "backup@100.118.57.39:tank/vault/localhost-verdandi/20240325_charles";
      #         sendOptions = "w c";
      #         sshKey = "/var/lib/syncoid/id_ed25519";
      #         extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
      #     };
      # FIXME syncoid SENDER needs `zfs allow backup create,receive,destroy,rollback,snapshot,hold,release,mount zroot`
      # RECEIVER needs zfs allow backup receive,mount,create
      # };
    };
  }; # END of services

  environment = {
    systemPackages = with pkgs; [ ansible ];
  };

  networking = {
    hostId = "555dafd6"; # head -c 8 /etc/machine-id
    hostName = "badb";
    networkmanager.enable = true;
    # nmcli con show
    # nmcli con modify HotelWifiName wifi.cloned-mac-address 70:48:f7:1a:2b:3c
    # nmcli device disconnect wlp0s20f3
    # nmcli device connect wlp0s20f3
    useDHCP = lib.mkDefault true;
  };

  hardware = {
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };

  boot.initrd.availableKernelModules = [
    "uhci_hcd"
    "ehci_pci"
    "ata_piix"
    "ahci"
    "firewire_ohci"
    "tifm_7xx1"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
