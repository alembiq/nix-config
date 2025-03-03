{
  pkgs,
  lib,
  config,
  ...
}:
{
  services = {
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  programs.wshowkeys.enable = true;
  #   programs.dconf.enable = true;
  #   programs.hyprland.withUWSM = true;
  xdg = {
    mime.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      config.common.default = "*";
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        # pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
        # https://discourse.nixos.org/t/xdg-portals-all-broken/48308/16
      ];
      xdgOpenUsePortal = true;
    };

  };

}
