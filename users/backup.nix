{ pkgs, ... }:
{
  users.users.backup = {
    isSystemUser = true;
    group = "nogroup";
    extraGroups = [ ];
    shell = "/run/current-system/sw/bin/sh";
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEcw4rXr29oIqoVzrNPOlRh+9e41w9Wo+r9T0jaTu+p verdandi@kubera-20250905"
      ];
    };
  };
} # END of users.users.backup
