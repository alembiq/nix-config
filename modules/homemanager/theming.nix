{pkgs, config, lib, ...}:
{
    gtk = lib.mkForce {
        enable = true;
        theme = {
            name = "Nordic";
            package = pkgs.nordic;
        };
        iconTheme = {
            name = "Nordzy";
            package = pkgs.nordzy-icon-theme;
        };
        cursorTheme = {
            name = "Nordzy-cursors";
            package = pkgs.nordzy-cursor-theme;
            size = 32;
        };
    };

    dconf = {
        settings = {
            "org/gnome/desktop/interface" = {
                gtk-theme = "Nordic";
                cursor-theme = "Nordzy-cursors";
            };
            "org/gnome/desktop/wm/preferences" = {
                theme = "Nordzy";
            };
        };
    };

    stylix = { #FIXME stylix ignoring: chromium, pinentry
        base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml"; # https://raw.githubusercontent.com/ada-lovecraft/base16-nord-scheme/master/nord.yaml
        polarity = "dark";
        autoEnable = true;
        targets.firefox.enable = true;
        targets.gtk.enable = true;
        targets.hyprland.enable = true;
        targets.sway.enable = true;
        targets.swaylock.enable = true;
        targets.vscode.enable = true;
        targets.waybar.enable = false;
        targets.wezterm.enable = false;
        targets.wpaperd.enable = true;
        targets.xresources.enable = true;
    };
}
