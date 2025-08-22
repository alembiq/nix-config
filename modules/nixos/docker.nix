{ pkgs, config, ... }:
{
  programs = {
    virt-manager.enable = true;
  };

  # https://wiki.nixos.org/wiki/Docker
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
