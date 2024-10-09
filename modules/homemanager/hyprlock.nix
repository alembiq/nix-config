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
        grace = 10;
        disable_loading_bar = true;
        no_fade_in = false;
      };
      background = [
        {
          path = "${config.home.homeDirectory}/pictures/wallpapers/drone-5.jpg";
          # blur_passes = 2;
          # noise = 0.0117;
          # contrast = 0.8916;
          # brightness = 0.8172;
          # vibrancy = 0.1696;
          # vibrancy_darkness = 0.0;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -20";
          outer_color = config.lib.stylix.colors.base00;
          inner_color = config.lib.stylix.colors.base01;
          font_color = config.lib.stylix.colors.base05;
        }
      ];
      label = [
        {
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          font_size = 160;
          position = "0, 370";
          halign = "center";
          valign = "center";
          color = config.lib.stylix.colors.base04;
        }
        {
          text = "    $USER";

          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 18;
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
