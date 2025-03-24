{
  config,
  lib,
  pkgs,
  disko,
  nixos-hardware,
  ...
}:

{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../default.nix
    ../default-workstation.nix
    # ../modules/nixos/remotebuilder.nix
    ../../modules/nixos/greetd.nix
    ../../modules/nixos/audio.nix
    # ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/audio.nix
    ../../users/charles.nix
    ../../users/charles-mail.nix
    ../../users/charles-ssh.nix
    ../../users/backup.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/stylix.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

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

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  services = {
    power-profiles-daemon.enable = false;
    # zram-generator = {
    #     enable = true;
    #     settings.zram0 = {
    #         compression-algorithm = "zstd";
    #         zram-size = "ram * 2";
    #     };
    # };
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

}
