{ pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.steiner = {
    isNormalUser = true;
    initialHashedPassword = "$6$v6PQnaaF2/FOFBtq$RGM/DUzJogCWKjdEJCxA0KFnLTBTxzIWDqgUUTAW2ZTAtxFrl4omDeXs3Nmu4KULBc1Lofn0Fh4IrnkDmuVbI/"; # FIXME update password
    extraGroups = [
      "wheel"
    ]
    ++ ifTheyExist [
      "networkmanager"
      "nixconfig"
      "docker"
    ];
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICpwhetQlDF3BpFx1r9PhZxKNC0S4hKVSamZjqLwKDpr stein@lenovo"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMocIPg9yzSy7JDalJuAy0o9aDizlEqV49jwrCB3W9G tom@pbk-steiner"
      ];
    };
  }; # END of users.users.steiner
  home-manager = {
    users.steiner = {
      imports = [ ./default.nix ];
      programs.git = {
        userName = "Tomas Steiner";
        userEmail = "t.steiner@email.cz";
        extraConfig = {
          pull.rebase = "true";
        };
      }; # END of home-manager.users.steiner.programs
      services.ssh-agent.enable = "true";
      home.stateVersion = "23.11";
    }; # END of home-manager.users.steiner
  }; # END of home-manager
}
