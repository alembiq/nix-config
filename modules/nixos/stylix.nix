{pkgs, config, ...}:
{
    stylix = { #FIXME stylix ignoring targers; missing chromium, firefox, vscode, pinentry, pavucontrol, easyeffects
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
        cursor = { #FIXME cursors
            package = pkgs.nordzy-cursor-theme;
            name = "Nordzy-cursors";
            };
        image = pkgs.fetchurl { # https://i.redd.it/drtekja8qmib1.jpg
            url = "https://i.redd.it/drtekja8qmib1.jpg"; #https://preview.redd.it/mgvxniw0h3h61.jpg?width=5120&format=pjpg&auto=webp&s=da592cd05daf1830d480dd88240048e8d2300ae7";
            sha256 = "sha256-Lji8QWxNMUPOli3+PlQy9satSf21lYGsdpK6doQHFEY=";
        };
        fonts = { # fc-lsit
            sizes = {
                applications = 12;
                desktop = 12;
                popups = 12;
                terminal = 12;
            };
            monospace = {
                name = "FiraCode Nerd Font Mono"; #TODO try cascadia-code
                package = pkgs.fira-code-nerdfont;
            };
            # serif = config.stylix.fonts.monospace;
            # sansSerif = config.stylix.fonts.monospace;
            # emoji = config.stylix.fonts.monospace;
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
    }; #END of STYLIX
}
