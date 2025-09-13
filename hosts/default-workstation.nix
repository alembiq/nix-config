{
  config,
  lib,
  pkgs,
  ...
}:

{

  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  environment.systemPackages = with pkgs; [

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
    # yubikey-touch-detector.enable = true;
    appimage = {
      binfmt = true;
      enable = true;
      package = pkgs.appimage-run;
    };
  };

  services = {
    udisks2 = {
      enable = true;
      package = pkgs.udisks;
    };
    # pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-personalization
    ];
  };

  hardware = {
    # gpgSmartcards.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      services = {
        # login.u2fAuth = true;
        # sudo.u2fAuth = true;
        swaylock = { };
        hyprlock = { };
        greetd = {
          #   enableGnomeKeyring = true;
          #   gnupg = {
          #     enable = true;
          #     storeOnly = true;
          #   };
        };
      };
    };
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "30s";
  };

}
