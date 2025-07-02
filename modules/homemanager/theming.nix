{
  pkgs,
  config,
  lib,
  ...
}:
{
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml"; # https://raw.githubusercontent.com/ada-lovecraft/base16-nord-scheme/master/nord.yaml

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
