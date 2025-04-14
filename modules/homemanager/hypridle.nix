{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${pkgs.grim}/bin/grim ~/.local/screenlock.png && ${pkgs.hyprlock}/bin/hyprlock && loginctl lock-session ";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };
      listener = [

        {
          timeout = 270;
          on-timeout = "${pkgs.light}/bin/light -S 25";
          on-resume = "${pkgs.light}/bin/light -I";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session && pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 330;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "if [ $(cat /sys/class/power_supply/AC/online) != 1 ]; then ${pkgs.systemd}/bin/systemctl suspend; fi ";
        }
      ];
    };
  };
}
