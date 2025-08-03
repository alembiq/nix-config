{ pkgs, config, ... }:
{
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml"; # https://raw.githubusercontent.com/ada-lovecraft/base16-nord-scheme/master/nord.yaml
    polarity = "dark";
    autoEnable = true;
    targets.chromium.enable = true;
    targets.console.enable = true;
    targets.nixos-icons.enable = true;
    opacity = {
      applications = 0.8;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.7;
    };
    cursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
    };
    fonts = {
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
        terminal = 12;
      };
      monospace = {
        name = "FiraCode Nerd Font Mono"; # TODO try cascadia-code
        package = pkgs.nerd-fonts.fira-code;
      };

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  }; # END of STYLIX
}
