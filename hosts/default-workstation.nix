{
  config,
  lib,
  pkgs,
  ...
}:

{

  services.logind.lidSwitchExternalPower = "ignore";

  environment.systemPackages = with pkgs; [
    opensc
    pcsctools
    libu2f-host
    yubikey-personalization
    yubioath-flutter # yubikey-personalization-gui
    yubikey-manager
    yubikey-touch-detector
    git
    tree
    bc
    cifs-utils
    btrfs-progs
    lm_sensors
    easyeffects
    pwvucontrol # alternatives qpwgraph ncpamixer helvum pavucontol
  ];

  programs = {
    yubikey-touch-detector.enable = true;
    appimage = {
      binfmt = true;
      enable = true;
      package = pkgs.appimage-run;
    };
    thunar.enable = true;
  };

  services = {
    udisks2 = {
      enable = true;
      package = pkgs.udisks;
    };
    pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-personalization
      libu2f-host
    ];
  };

  hardware = {
    gpgSmartcards.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      # yubico = { #nix-shell --command 'ykinfo -s' -p yubikey-personalization
      #     enable = true;
      #     # debug = true;
      #     mode = "challenge-response";
      #     # id = [
      #     #     "19937800" #KK2023
      #     #     "23126686" #KK2024NANO
      #     #     ];
      # };
      # u2f.enable = true;
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        swaylock = { }; # to enable swaylock auth FIXME
        hyprlock = { }; # to enable hyprlock auth FIXME
        greetd = {
          #   enableGnomeKeyring = true;
          gnupg = {
            enable = true;
            storeOnly = true;
          };
        };
      };
    };
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "30s";
  };

  fileSystems."/mnt/media" = {
    device = "//10.0.42.208/media";
    fsType = "cifs";
    options =
      let
        automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
      in
      [
        "${automount_opts},credentials=~/.config/fileserver-samba,uid=1111,gid=100"
      ];
    # FIXME dynamic GID, UID, sops
  };
  fileSystems."/mnt/video" = {
    device = "//10.0.42.208/video";
    fsType = "cifs";
    options =
      let
        automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
      in
      [
        "${automount_opts},credentials=~/.config/fileserver-samba,uid=1111,gid=100"
      ];
    # FIXME dynamic GID, UID, sops
  };
  fileSystems."/mnt/library" = {
    device = "//10.0.42.208/library";
    fsType = "cifs";
    options =
      let
        automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
      in
      [
        "${automount_opts},credentials=~/.config/fileserver-samba,uid=1111,gid=100"
      ];
    # FIXME dynamic GID, UID, sops
  };
  fileSystems."/mnt/audio" = {
    device = "//10.0.42.208/audio";
    fsType = "cifs";
    options =
      let
        automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
      in
      [
        "${automount_opts},credentials=/home/charles/.config/fileserver-samba,uid=1111,gid=100"
      ];
    # FIXME dynamic GID, UID, sops
  };
  fileSystems."/mnt/vault" = {
    device = "//10.0.42.208/vault";
    fsType = "cifs";
    options =
      let
        automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
      in
      [
        "${automount_opts},credentials=~/.config/fileserver-samba,uid=1111,gid=100"
      ];
    # FIXME dynamic GID, UID, sops
  };

}
