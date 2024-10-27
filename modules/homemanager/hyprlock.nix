{
  config,
  lib,
  vars,
  ...
}:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
        disable_loading_bar = true;
        no_fade_in = false;
      };
      background = [
        {
          #   path = "${config.home.homeDirectory}/pictures/wallpapers/drone-5.jpg";
          path = "/tmp/screenshot.png";
          blur_passes = 1;
          noise = 1.17e-2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -20";
          outer_color = "rgb(${config.lib.stylix.colors.base00})";
          inner_color = "rgb(${config.lib.stylix.colors.base01})";
          font_color = "rgb(${config.lib.stylix.colors.base05})";
        }
      ];
      label = [
        {
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          font_size = 160;
          position = "0, 370";
          halign = "center";
          valign = "center";
          color = "rgb(${config.lib.stylix.colors.base04})";
        }
        {
          text = "  $USER ";
          font_size = 32;
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
