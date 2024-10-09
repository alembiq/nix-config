{
  config,
  lib,
  pkgs,
  ...
}:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-enviroment";
    executable = true;
    text = ''
      dbus-update-activation-enviroment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
    -t warning \
    -m 'What do you want to do?' \
    -b 'Poweroff' 'systemctl poweroff' \
    -b 'Reboot' 'systemctl reboot'
  '';
  modifier = "Mod4";
  term = "${pkgs.wezterm}/bin/wezterm";
  menu = "wofi --show drun | xargs swaymsg exec --";
in
{

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      dbus-sway-environment
      swaylock-effects
      swaysettings
      swayidle
      sway-audio-idle-inhibit
      swaynotificationcenter
      swayosd
    ];
  };

  # services.swayidle = {
  #     enable = true;
  #     # https://github.com/khaneliman/khanelinix/blob/main/modules/home/desktop/addons/swayidle/default.nix
  #     # package = nixpkgs-wayland.packages.${system}.swayidle;
  #     events = [
  #         {
  #             event = "before-sleep";
  #             command = "${pkgs.swaylock-effects}/bin/swaylock";
  #             }
  #         # {
  #         #     event = "after-resume";
  #         #     command = "${pkgs.swaylock-effects}/bin/swaymsg 'output * dpms on'";
  #         # }
  #         {
  #             event = "lock";
  #             command = "${pkgs.swaylock-effects}/bin/swaylock";
  #         }
  #         # {
  #         #     event = "unlock";
  #         #     command = "${pkgs.swaylock-effects}/bin/swaymsg 'output * dpms on'";
  #         # }
  #     ];
  #   timeouts = [
  #     {
  #       timeout = 300;
  #       command = "${pkgs.swaylock-effects}/bin/swaylock";
  #     }
  #     # {
  #     #   timeout = 330;
  #     #   command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
  #     # }
  #   ];
  # };

  # systemd.user.services.swayidle = {
  #     Unit.PartOf = [ "sway-session.target" ];
  #     Install.WantedBy = [ "sway-session.target" ];
  #     Service = {
  #         Environment = "PATH=${pkgs.bash}/bin:${config.wayland.windowManager.sway.package}/bin";
  #         ExecStart = ''
  #             ${pkgs.swayidle}/bin/swayidle -w \
  #                 timeout 300 "${pkgs.swaylock-effects}/bin/swaylock" \
  #                 timeout 360 '${pkgs.swaylock-effects}/bin/swaymsg "output * dpms off"' \
  #                     resume '${pkgs.swaylock-effects}/bin/swaymsg "output * dpms on"' \
  #                 before-sleep "${pkgs.swaylock-effects}/bin/swaylock" \
  #                 lock "${pkgs.swaylock-effects}/bin/swaylock" \
  #                 unlock 'pkill -xu $USER -SIGUSR1 ${pkgs.swaylock-effects}/bin/swaylock'
  #         '';
  #         Restart = "on-failure";
  #     };
  # };
  # https://git.sbruder.de/simon/nixos-config/commit/e17aa4bc6b99856c81db991815813e0a12e00977

  # programs.waybar.enable = true;

  systemd.user.services.kanshi = {
    enable = true;
    description = "kanshi daemon";
    wantedBy = [ "sway-session.target" ];
    after = [ ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kanshi}/bin/kanshi "; # -c kanshi_config_file $XDG_CONFIG_HOME/kanshi/config
    };
  };

}
