{
  config,
  lib,
  pkgs,
  modulesPath,
  stylix,
  nixos-hardware,
  ...
}:
let
  vlc = pkgs.vlc.override {
    libbluray = pkgs.libbluray.override {
      withJava = true;
      withAACS = true;
      withBDplus = true;
    };
  };
in
# db for libaacs: http://www.videolan.org/developers/libaacs.html
# mkdir -p ~/.config/aacs
# (
# 	cd ~/.config/aacs
# 	wget http://www.labdv.com/aacs/KEYDB.cfg
# )
{

  # hardware.system76.power-daemon.enable = true;
  hardware.nfc-nci.enable = true; # test with pcsc_scan
  services.desktopManager.cosmic.enable = true;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/nixos/greetd.nix
    ./disk-config.nix
    ../default.nix
    ../default-workstation.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/bluetooth.nix
    # ../modules/nixos/remotebuilder.nix
    ../../users/charles.nix
    ../../users/charles-mail.nix
    ../../users/charles-ssh.nix
    ../../users/backup.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/stylix.nix
    #    ../../modules/nixos/docker.nix
    ../../modules/nixos/plasma6.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
  ];

  home-manager = {
    users.charles = {
      imports = [
        ../../modules/homemanager/theming.nix
        ../../modules/homemanager/mail.nix
        ../../modules/homemanager/waybar.nix
        ../../modules/homemanager/hyprland.nix
        ../../modules/homemanager/hyprlock.nix
        ../../modules/homemanager/hypridle.nix
        # ../../modules/homemanager/wezterm.nix
        ../../modules/homemanager/firefox.nix
        ../../modules/homemanager/nextcloud.nix
        ../../modules/homemanager/photography.nix
        ../../modules/homemanager/vscodium.nix
        ../../modules/homemanager/sway.nix
        ../../modules/homemanager/wofi.nix
        ../../users/charles-workstation.nix
        stylix.homeModules.stylix
      ];

      home = {
        packages = with pkgs; [
          prusa-slicer
          openscad-unstable
          calibre
          poppler_utils # pdf tools
          overskride # bluetooth UI
          deluge
          # makemkv handbrake libaacs libbluray libdvdcss
          krita
          dconf
        ];
        stateVersion = "23.11";
      }; # END of home-manager.users.charles.home
    }; # END of home-manager.users.charles
  }; # END of home-manager
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand"; # power, performance, ondemand
  };

  #   hardware.system76.power-daemon.enable = true;
  services = {
    # system76-scheduler.settings.cfsProfiles.enable = true;
    #   power-profiles-daemon.enable = true; # ppd, not default
    tlp = {
      enable = true;
      settings = {
        #     # CPU_BOOST_ON_AC = 1;
        #     # CPU_ENERGY_PERF_POLICY_ON_AC = "performance"; #balance_performance
        #     # CPU_HWP_DYN_BOOST_ON_AC = 1;
        #     # CPU_MIN_PERF_ON_AC = 0;
        #     # CPU_MAX_PERF_ON_AC = 90;
        #     # CPU_SCALING_GOVERNOR_ON_AC = "performance";
        #     # PLATFORM_PROFILE_ON_AC = "performance"; # balance_performance
        #     RUNTIME_PM_ON_AC = "on";

        #     # CPU_BOOST_ON_BAT = 0;
        #     # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        #     # CPU_HWP_DYN_BOOST_ON_BAT = 0;
        #     # CPU_MIN_PERF_ON_BAT = 0;
        #     # CPU_MAX_PERF_ON_BAT = 50;
        #     # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        #     # PLATFORM_PROFILE_ON_BAT = "low-power";
        #     RUNTIME_PM_ON_BAT = "auto";

        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          energy_performance_preference = "performance"; # performance (0), balance_performance (4), default (6), balance_power (8), or power (15)
          governor = "performance"; # performance powersave
          platform_profile = "balance_power"; # low-power balanced performance
          scaling_min_freq = 400000;
          scaling_max_freq = 3200000;
          turbo = "auto";

          enable_thresholds = true;
          start_threshold = 60;
          stop_threshold = 80;

        };
        battery = {
          energy_performance_preference = "power";
          governor = "powersave";
          platform_profile = "low-power";
          scaling_min_freq = 400000;
          scaling_max_freq = 1800000;
          turbo = "never";
        };
      };
    };
    rpcbind.enable = true;
  };

  #  systemd.mounts = [
  #    {
  #      type = "nfs";
  #      mountConfig = {
  #        Options = "noatime";
  #      };
  #      what = "10.0.42.26:/mnt/forge";
  #      where = "/mnt/forge-nfs";
  #    }
  #  ];
  #  systemd.automounts = [
  #    {
  #      wantedBy = [ "multi-user.target" ];
  #      automountConfig = {
  #        TimeoutIdleSec = "600";
  #      };
  #      where = "/mnt/forge-nfs";
  #    }
  #  ];

  fileSystems."/mnt/forge-smb" = {
    device = "//10.0.42.26/forge";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0640,dir_mode=0750";

      in
      [
        "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${toString config.users.users.charles.uid},gid=${toString config.users.groups.users.gid}"
      ];
  };
  #,uid=${toString config.users.users.charles.uid},gid=${toString config.users.groups.charles.gid}"];

  #TODO fingerprint

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  services = {

    # 20250520    kmscon.enable = true;
    deluge.config = ''
      {
                  download_location = "/srv/torrents/";
              }'';
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
      datasets."zpool/home/charles/workspace" = {
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
  }; # END of services

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  }; # END of programs

  #TODO 4G modem
  systemd.services.ModemManager.enable = true;
  networking.modemmanager.enable = true;
  environment = {
    systemPackages = with pkgs; [
      modemmanager
      modem-manager-gui
      ventoy-full-qt
    ];
  };

  networking = {
    hostId = "cf4e3181"; # head -c 8 /etc/machine-id
    hostName = "verdandi";
    networkmanager.enable = true;
    # nmcli con show
    # nmcli con modify HotelWifiName wifi.cloned-mac-address 70:48:f7:1a:2b:3c
    # nmcli device disconnect wlp0s20f3
    # nmcli device connect wlp0s20f3
    useDHCP = lib.mkDefault true;
  };

  #TODO paired BT deviced
  hardware = {
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    intel-gpu-tools.enable = true;
  };

  #   security.protectKernelImage = false; # hibernate

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        consoleMode = "auto"; # FIXME same console size everywhere - systemd-bootd limitation :(
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      # https://github.com/NixOS/nixpkgs/issues/219239
      kernelModules = [ "i915" ];
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usbhid"
        "uas"
        "sd_mod"
      ];
    };
    kernelModules = [
      "kvm-intel"
      "thinkpad_acpi"
    ];
    kernelParams = [
      "resume=/dev/disk/by-partlabel/disk-nvme-plainSwap"
      #      "mitigations=off"
      "i915.enable_psr=0"
      "i915.enable_fbc=1"
      "i915.fastboot=1"
      "i915.enable_dc=0"
      "i915.enable_guc=3"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    extraModprobeConfig = ''
      options thinkpad_acpi fan_control=1
    '';
    supportedFilesystems = [ "nfs" ];
    zfs = {
      forceImportRoot = false;
      allowHibernation = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
