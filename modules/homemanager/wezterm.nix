{pkgs, config, ...}@inputs:
{
    programs.wezterm = {
        enable = true;
        package = inputs.wezterm.packages.${pkgs.system}.default;
        extraConfig = let inherit (config.stylix) fonts; in ''
            local wezterm = require 'wezterm';
            local config = wezterm.config_builder()


            config.enable_tab_bar = true
            config.hide_tab_bar_if_only_one_tab = true
            config.use_fancy_tab_bar = false
            config.scrollback_lines = 5000
            config.enable_scroll_bar = true
            config.font = wezterm.font 'FiraCode Nerd Font Mono'
            config.color_scheme = 'custom'
            config.check_for_updates = false
            config.warn_about_missing_glyphs=false

            return config
            '';
        colorSchemes.custom = with config.lib.stylix.colors.withHashtag; {
            ansi = [ base00 red green yellow blue magenta cyan base05 ];
            brights = [ base03 red green yellow blue magenta cyan base07 ];
            background = base00;
            cursor_bg = base05;
            cursor_border = base05;
            cursor_fg = base00;
            foreground = base05;
            selection_bg = base05;
            selection_fg = base00;
        };
    };
}
