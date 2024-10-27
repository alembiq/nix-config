{
  pkgs,
  config,
  lib,
  ...
}:
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
}
