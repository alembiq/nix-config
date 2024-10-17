{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${pkgs.grim}/bin/grim /tmp/screenshot.png && ${pkgs.hyprlock}/bin/hyprlock && loginctl lock-session ";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 300;
          on-timeout = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 380;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        }
        {
          timeout = 600;
          on-timeout = "if [ $(cat /sys/class/power_supply/AC/online) = 0 ]; then ${pkgs.systemd}/bin/systemctl suspend; fi  ";
        }
      ];
    };
  };
}
