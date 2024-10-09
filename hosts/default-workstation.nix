{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    opensc
    pcsctools
    libu2f-host
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-manager
    yubikey-touch-detector
    powertop
    git
    tree
    cifs-utils
    btrfs-progs
    lm_sensors
    easyeffects
    pavucontrol # alternatives qpwgraph ncpamixer helvum
  ];

  programs = {
    yubikey-touch-detector.enable = true;
    appimage = {
      binfmt = true;
      enable = true;
      package = pkgs.appimage-run;
    };
  };

  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-personalization
      libu2f-host
    ];
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = builtins.concatStringsSep " " [
            "${pkgs.greetd.tuigreet}/bin/tuigreet"
            "--asterisks"
            "--remember"
            "--time"
            "--sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
            "--time-format '%I:%M %p | %a • %h | %F'"
            "--cmd Hyprland"
          ];
        };
        user = "charles";
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };
    xserver = {
      enable = true;
    };
  };

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  hardware = {
    gpgSmartcards.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  security = {
    rtkit.enable = true;
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
        swaylock = { }; # to enable swaylock auth
        hyprlock = { }; # to enable hyprlock auth
        greetd = {
          enableGnomeKeyring = true;
          gnupg = {
            enable = true;
            storeOnly = true;
          };
        };
      };
    };
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  fileSystems."/mnt/media" = {
    device = "//10.0.42.208/media";
    fsType = "cifs";
    options =
      let
        automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
      in
      [
        "${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"
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
        "${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"
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
        "${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"
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
        "${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"
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
        "${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"
      ];
    # FIXME dynamic GID, UID, sops
  };

}
