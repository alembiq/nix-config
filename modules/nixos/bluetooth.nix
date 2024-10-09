{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blueberry
    # blueman
  ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  #   services.blueman.enable = true;
}
