{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.desktopManager.plasma6.enable = true;
  services.power-profiles-daemon.enable = true;
  services.tlp.enable = lib.mkForce false;
}
