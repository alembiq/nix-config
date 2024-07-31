
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
                ];
                xdgOpenUsePortal = true;
            };

        };

}
