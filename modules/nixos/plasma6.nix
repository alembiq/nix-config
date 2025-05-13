{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.desktopManager.plasma6.enable = true;
  services.power-profiles-daemon.enable = false;
#  services.tlp.enable = lib.mkForce false;
}
