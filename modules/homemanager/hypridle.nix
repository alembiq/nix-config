{ pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pkgs.grim}/bin/grim ~/.local/screenlock.png && pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        unlock_cmd = "rm ~/.local/screenlock.png";
        before_sleep_cmd = "pkgs.hyprlock}/bin/hyprlock && ${pkgs.light}/bin/light -O && loginctl lock-session ";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 270;
          on-timeout = "${pkgs.light}/bin/light -S 25";
          on-resume = "${pkgs.light}/bin/light -I ";
        }
        {
          # Only lock if not docked at home
          timeout = 285;
          on-timeout = "if ! ${pkgs.usbutils}/bin/lsusb -v -d 17ef:3082 2>/dev/null | grep -q 'iSerial.*101C4333A'; then loginctl lock-session && ${pkgs.light}/bin/light -O && pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock; fi";
          on-resume = "${pkgs.light}/bin/light -I ";
        }
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on && ${pkgs.light}/bin/light -I ";
        }
        {
          timeout = 315;
          on-timeout = "if [ $(cat /sys/class/power_supply/AC/online) != 1 ]; then ${pkgs.light}/bin/light -O && ${pkgs.systemd}/bin/systemctl suspend; fi ";
          on-resume = "hyprctl dispatch dpms on && ${pkgs.light}/bin/light -I ";
        }
      ];
    };
  };
}
