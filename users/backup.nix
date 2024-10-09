{ pkgs, ... }:
{
  users.users.backup = {
    isNormalUser = true;
    createHome = false;
    home = "/var/lib/syncoid";
    extraGroups = [ ];
    shell = "/run/current-system/sw/bin/sh";
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFOEYBSiSuH2QoVmvQojJXMtOWFMHka6JCARceEyJIm kubera-2022-05-31"
      ];
    };
  };
} # END of users.users.backup
