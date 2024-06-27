
{ pkgs, lib, config, ... }:
{
        services = {
            dbus.enable = true;
            gnome.gnome-keyring.enable = true;
        };
        xdg = {
            portal = {
                enable = true;
                wlr.enable = true;
                extraPortals = [
                    pkgs.xdg-desktop-portal-hyprland
                ];
            };

        };

#         security = {
#             pam.services = {
#                 swaylock = {
#                     text = ''
#                         auth include login
#                     '';
#                 };
#             };
#         };
}
