{
  config,
  lib,
  pkgs,
  modulesPath,
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

hardware.system76.power-daemon.enable = true;
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
    ../../modules/nixos/docker.nix
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
        ../../modules/homemanager/wezterm.nix
        ../../modules/homemanager/firefox.nix
        ../../modules/homemanager/nextcloud.nix
        ../../modules/homemanager/photography.nix
        ../../modules/homemanager/vscodium.nix
        ../../modules/homemanager/sway.nix
        ../../modules/homemanager/wofi.nix
        ../../users/charles-workstation.nix
      ];

      home = {
        packages = with pkgs; [
          prusa-slicer
          openscad #FIXME 20250523 -unstable
          calibre
          poppler_utils # pdf tools
          overskride # bluetooth UI
          deluge
          # makemkv handbrake libaacs libbluray libdvdcss
          waveterm
          krita
        ];
        stateVersion = "23.11";
      }; # END of home-manager.users.charles.home
    }; # END of home-manager.users.charles

  }; # END of home-manager

    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 90;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 50;

        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };

  services.thermald.enable = true;

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
  services.rpcbind.enable = true;

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

  #TODO new kernel
  #TODO fingerprint
  #TODO NFC
  #TODO hibernate

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
    syncoid = {
      # FIXME do pull insted of push
      user = "backup";
      enable = true;
      interval = "*:35";
      commonArgs = [
        "--no-sync-snap"
        "--no-privilege-elevation"
        # "--debug"
      ];
      commands = {
        "nixos" = {
          source = "zpool/nixos/etc";
          target = "verdandi@kubera:tank/vault/localhost-verdandi/20240325_nixos";
          sendOptions = "wp"; # raw, copy properties
          recvOptions = "u";
          #TODO syncoid path and the key /var/lib/syncoid/id_ed25519 ? user backup
          sshKey = "/var/lib/syncoid/id_ed25519";
          extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
        };
        "home" = {
          source = "zpool/home/charles";
          target = "verdandi@kubera:tank/vault/localhost-verdandi/20240325_charles";
          sendOptions = "w"; # raw
          recvOptions = "u";
          sshKey = "/var/lib/syncoid/id_ed25519";
          extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
        };
        "workspace" = {
          source = "zpool/home/charles/workspace";
          target = "verdandi@kubera:tank/vault/localhost-verdandi/20240325_workspace";
          sendOptions = "w"; # raw
          recvOptions = "u";
          sshKey = "/var/lib/syncoid/id_ed25519";
          extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
        };
        # FIXME syncoid SENDER needs `zfs allow backup create,receive,destroy,rollback,snapshot,hold,release,mount zroot`
        # FIXME syncoid RECEIVER needs zfs allow backup receive,mount,create
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
  };

  security.protectKernelImage = false; # hibernate

  boot = {
    kernelPackages = pkgs.linuxPackages; # _zen; # https://nixos.wiki/wiki/Linux_kernel#List_available_kernels
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
        "thinkpad_acpi"
      ];
    };
    kernelModules = [
      "kvm-intel"
      "thinkpad_acpi"
    ];
    kernelParams = [
      "resume=/dev/disk/by-partlabel/disk-nvme-plainSwap"
      "mitigations=off"
      "i915.enable_psr=0"
      "i915.enable_fbc=1"
      "i915.fastboot=1"
      "i915.enable_dc=0"
      "i915.enable_guc=3"
      #      "thinkpad_acpi.fan_control=1"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    supportedFilesystems = [ "nfs" ];
    zfs = {
      forceImportRoot = false;
      allowHibernation = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
