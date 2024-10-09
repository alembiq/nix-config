{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  networking = {
    hostId = "555dafd6"; # head -c 8 /etc/machine-id
    hostName = "badb";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    # wireless.enable = true;
  };

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ ];
      availableKernelModules = [
        "uhci_hcd"
        "ehci_pci"
        "ata_piix"
        "ahci"
        "firewire_ohci"
        "tifm_7xx1"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "sdhci_pci"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

}
