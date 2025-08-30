{
  config,
  lib,
  pkgs,
  ...
}:

{

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = builtins.concatStringsSep " " [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--asterisks"
            "--remember"
            "--time"
#            "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
            "--sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
            "--time-format '%I:%M %p | %a • %h | %F'"
            "--cmd Hyprland"
          ];
        };
        user = "charles";
      };
    };

  };

}
