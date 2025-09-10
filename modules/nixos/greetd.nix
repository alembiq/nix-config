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
      useTextGreeter = true;
      settings = {
        default_session = {
          command = builtins.concatStringsSep " " [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--asterisks"
            "--remember"
            "--time"
            "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
            "--xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions"
            "--time-format '%I:%M %p | %a • %h | %F'"
            "--cmd bash"
          ];
        };
        user = "charles";
      };
    };

  };

}
