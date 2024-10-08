
{ pkgs, lib, config, ... }:
{
        services = {
            dbus.enable = true;
            gnome.gnome-keyring.enable = true;
        };
        programs.wshowkeys.enable = true;
        xdg = {
            portal = {
                enable = true;
                wlr.enable = true;
                extraPortals = [
                    pkgs.xdg-desktop-portal-hyprland
                    pkgs.xdg-desktop-portal-wlr
                    pkgs.xdg-desktop-portal-gtk
                    # https://discourse.nixos.org/t/xdg-portals-all-broken/48308/16
                ];
                xdgOpenUsePortal = true;
            };

        };

}
