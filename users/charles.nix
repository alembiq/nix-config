{ pkgs, config, ... }:
let
  # the issue is that mailboxes is stricter now, so fake entries have to be injected using named-mailboxes.
  list-mailboxes = pkgs.writeScriptBin "list-mailboxes" ''
    find ${config.home-manager.users.charles.accounts.email.maildirBasePath}/$1 -type d -name cur | sort | sed -e 's:/cur/*$::' -e 's/ /\\ /g' | uniq | tr '\n' ' '
  '';
  list-empty-mailboxes = pkgs.writeScriptBin "list-empty-mailboxes" ''
    find ${config.home-manager.users.charles.accounts.email.maildirBasePath}/$1 -type d -exec bash -c 'd1=("$1"/cur/); d2=("$1"/*/); [[ ! -e "$d1" && -e "$d2" ]]' _ {} \; -printf "%p "
  '';
  autodiscoverMailboxes = path: "mailboxes `${list-mailboxes}/bin/list-mailboxes ${path}`";
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.charles = {
    isNormalUser = true;
    description = "Karel";
    home = "/home/charles";
    uid = 1111;
    initialHashedPassword = "$6$v6PQnaaF2/FOFBtq$RGM/DUzJogCWKjdEJCxA0KFnLTBTxzIWDqgUUTAW2ZTAtxFrl4omDeXs3Nmu4KULBc1Lofn0Fh4IrnkDmuVbI/"; # mkpasswd -m SHA-512
    extraGroups =
      [ "wheel" ]
      ++ ifTheyExist [
        "input"
        "audio"
        "video"
        "networkmanager"
        "systemd-journal"
        "disk"
        "dialout"
        "cdrom"
        "docker"
        "tty"
      ];
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRfpy5Q0luwq8g01/slcTAK+Pzf6m9br0qIsyw1MQ+B charles@verdandi-2023-03-17"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq+f5IMK/uHgfdXmydOyKa5WxT/8ogqAOX3Mk0qkd4Q cardno:18_296_868" # YUBI KK 2024
      ];
    };
  }; # END users.users.charles
  home-manager = {
    users.charles = {
      imports = [ ./default.nix ];
      xdg.userDirs = {
        enable = true;
        documents = "$HOME/documents";
        pictures = "$HOME/pictures";
        music = "$HOME/audio";
        download = "$HOME/downloads";
      };
      stylix.targets.kde.enable = false; # FIXME https://github.com/danth/stylix/issues/340 remove when fixed
      programs = {
        git = {
          enable = true;
          userName = "Karel Kremel";
          userEmail = "charles@alembiq.net";
          extraConfig = {
            user.signing.key = "4A72D7FD235E50F93F6801A005F6EFFABE002CB2";
            commit.gpgSign = true;
            # gpg.program = "${config.programs.gpg.package}/bin/gpg2";
            pull.rebase = "true";
            push.autoSetupRemote = true;
          };
          aliases = {
            # back = "reset --soft HEAD~";
            undo = "reset HEAD~1 --mixed";
            graph = "log --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=short --graph";
            conflicts = "diff --name-only --diff-filter=U";
          };
        };
        gpg = {
          enable = true;
          publicKeys = [
            # https://discourse.nixos.org/t/gpg-smartcard-for-ssh/33689
            {
              source = ../secrets/KK-4A72D7FD235E50F93F6801A005F6EFFABE002CB2-2024-01-26.asc;
              trust = "ultimate";
            }
            {
              source = ../secrets/KO-B924244CA7E66DB473867B7CFE39AAD9091A1CD7-2024-01-26.asc;
              trust = "ultimate";
            }
            {
              source = ../secrets/KK-D25EEBEF376E7A1FFC2BBA00DAB8D3784DF29978-2023-09-14.asc;
              trust = "ultimate";
            }
            {
              source = ../secrets/KO-9A15295E39561003E02DE539576DCF9C4F332B1B-2023-09-14.asc;
              trust = "ultimate";
            }
          ];
          scdaemonSettings = {
            disable-ccid = true;
            pcsc-shared = true;
            reader-port = "Yubico Yubi";
          };
        };
      }; # END of home-manager.users.charles.programs
      home = {
        file.".ssh/YUBI-KK2024.pub" = {
          text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq+f5IMK/uHgfdXmydOyKa5WxT/8ogqAOX3Mk0qkd4Q cardno:18_296_868";
          onChange = "chmod 400 ~/.ssh/YUBI-KK2024.pub";
        };
        file.".ssh/YUBI-KO2024.pub" = {
          text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvCcxXJeASfL4+KHXO7XTia2dXVVwxvCv7rEqyfNF0o cardno:23_773_992";
          onChange = "chmod 400 ~/.ssh/YUBI-KO2024.pub";
        };
        packages = with pkgs; [
          #   pinentry-qt
          # pinentry-curses
          #   pinentry-gtk2
          pinentry-gnome3
          list-mailboxes
          list-empty-mailboxes
          htop
          ipcalc
        ];
        stateVersion = "23.11";
      }; # END of home-manager.users.charles.home
    }; # END of home-manager.users.charles
  };
}
