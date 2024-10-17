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
      accounts.contact.basePath = "~/.local/share/contacts/contacts/";
      accounts.email = {
        # Office365 oauth2 https://github.com/harishkrupo/oauth2ms or https://howto.cs.uchicago.edu/nix:mutt
        # maildirBasePath = "$HOME/Maildir";
        accounts."karelkremel@gmail.com" = {
          neomutt = {
            enable = true;
            extraConfig = ''
              mailboxes /home/charles/Maildir/karelkremel@gmail.com/Inbox /home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Drafts /home/charles/Maildir/karelkremel@gmail.com/ACCESS /home/charles/Maildir/karelkremel@gmail.com/MONEY /home/charles/Maildir/karelkremel@gmail.com/WORK /home/charles/Maildir/karelkremel@gmail.com/Kickstarter /home/charles/Maildir/karelkremel@gmail.com/Larp /home/charles/Maildir/karelkremel@gmail.com/Patreon /home/charles/Maildir/karelkremel@gmail.com/Photography "/home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Sent Mail" /home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Spam /home/charles/Maildir/karelkremel@gmail.com/[Gmail]/Bin
              named-mailboxes @gmail.com +Inbox
              named-mailboxes Junk "+[Gmail]/Spam"
              named-mailboxes Sent "+[Gmail]/Sent\ Mail"
              named-mailboxes Trash "+[Gmail]/Bin"
              folder-hook . "set sort=date ; set sort_aux=thread"
              set record = "+[Gmail]/Sent\ Mail"
              set postponed = "+[Gmail]/Drafts"
              set trash = "+[Gmail]/Bin"
            '';
          };
          flavor = "gmail.com";
          realName = "Karel Křemel";
          address = "karelkremel@gmail.com";
          userName = "karelkremel@gmail.com";
          gpg = {
            key = "4A72 D7FD 235E 50F9 3F68 01A0 05F6 EFFA BE00 2CB2";
            signByDefault = true;
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          notmuch.enable = true;
          primary = false;
          signature = {
            text = ''

              Karel Křemel
              karelkremel@gmail.com

            '';
            showSignature = "append";
          };
          # FIXME dynamic UID, sops passwordCommand = "cat ${config.sops.secrets."charles/email/ochman".path}";
          passwordCommand = "${pkgs.coreutils}/bin/cat /run/user/1111/secrets/charles/email/gmail";
        };
        accounts."karelkremel@karelkremel.com" = {
          neomutt = {
            enable = true;
            extraConfig = ''
              mailboxes /home/charles/Maildir/karelkremel@karelkremel.com/Inbox /home/charles/Maildir/karelkremel@karelkremel.com/Drafts /home/charles/Maildir/karelkremel@karelkremel.com/ACCESS /home/charles/Maildir/karelkremel@karelkremel.com/MONEY /home/charles/Maildir/karelkremel@karelkremel.com/WORK /home/charles/Maildir/karelkremel@karelkremel.com/Archive /home/charles/Maildir/karelkremel@karelkremel.com/ASATRU-eu /home/charles/Maildir/karelkremel@karelkremel.com/Heathenry /home/charles/Maildir/karelkremel@karelkremel.com/Larp /home/charles/Maildir/karelkremel@karelkremel.com/Photography /home/charles/Maildir/karelkremel@karelkremel.com/Junk /home/charles/Maildir/karelkremel@karelkremel.com/Sent /home/charles/Maildir/karelkremel@karelkremel.com/Trash
              named-mailboxes @karelkremel.com +Inbox
              folder-hook . "set sort=date ; set sort_aux=thread"
            '';
          };
          realName = "Karel Křemel";
          address = "karelkremel@karelkremel.com";
          userName = "karelkremel@karelkremel.com";
          gpg = {
            key = "4A72 D7FD 235E 50F9 3F68 01A0 05F6 EFFA BE00 2CB2";
            signByDefault = true;
          };
          imap = {
            host = "nextmail.alembiq.net";
            port = 993;
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          notmuch.enable = true;
          primary = true;
          signature = {
            text = ''

              Karel Křemel

              +420 777 123 644
              karelkremel@karelkremel.com
              www.karelkremel.com

            '';
            showSignature = "append";
          };
          passwordCommand = "${pkgs.coreutils}/bin/cat /run/user/1111/secrets/charles/email/karelkremel"; # FIXME dynamic UID, sops
          smtp = {
            host = "nextmail.alembiq.net";
          };
        };
        accounts."charles@alembiq.net" = {
          neomutt = {
            enable = true;
            extraConfig = ''
              mailboxes /home/charles/Maildir/charles@alembiq.net/Inbox /home/charles/Maildir/charles@alembiq.net/Drafts /home/charles/Maildir/charles@alembiq.net/ACCESS /home/charles/Maildir/charles@alembiq.net/MONEY /home/charles/Maildir/charles@alembiq.net/WORK /home/charles/Maildir/charles@alembiq.net/GIT /home/charles/Maildir/charles@alembiq.net/MUD-dev /home/charles/Maildir/charles@alembiq.net/Photography /home/charles/Maildir/charles@alembiq.net/vpsFree /home/charles/Maildir/charles@alembiq.net/Sent /home/charles/Maildir/charles@alembiq.net/Junk /home/charles/Maildir/charles@alembiq.net/Trash
              named-mailboxes @alembiq.net +Inbox
              folder-hook . "set sort=date ; set sort_aux=thread"
            '';
          };
          realName = "Karel Křemel";
          address = "charles@alembiq.net";
          userName = "charles@alembiq.net";
          gpg = {
            key = "4A72 D7FD 235E 50F9 3F68 01A0 05F6 EFFA BE00 2CB2";
            signByDefault = true;
          };
          imap = {
            host = "nextmail.alembiq.net";
            port = 993;
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          notmuch.enable = true;
          primary = false;
          signature = {
            text = ''

              Karel Křemel
              ALEMBIQ.net

              charles@alembiq.net
              +420-777 123 644
              www.alembiq.net

            '';
            showSignature = "append";
          };
          passwordCommand = "${pkgs.coreutils}/bin/cat /run/user/1111/secrets/charles/email/alembiq"; # FIXME dynamic UID, sops
          smtp = {
            host = "nextmail.alembiq.net";
          };
        };
        accounts."karel@ochman.info" = {
          neomutt = {
            enable = true;
            extraConfig = ''
              mailboxes /home/charles/Maildir/karel@ochman.info/Inbox /home/charles/Maildir/karel@ochman.info/Drafts  /home/charles/Maildir/karel@ochman.info/ACCESS /home/charles/Maildir/karel@ochman.info/MONEY /home/charles/Maildir/karel@ochman.info/WORK /home/charles/Maildir/karel@ochman.info/Goverment /home/charles/Maildir/karel@ochman.info/Sent /home/charles/Maildir/karel@ochman.info/Junk /home/charles/Maildir/karel@ochman.info/Trash
              named-mailboxes @ochman.info +Inbox
              folder-hook . "set sort=date ; set sort_aux=thread"
            '';
          };
          realName = "Karel Ochman";
          address = "karel@ochman.info";
          userName = "karel@ochman.info";
          gpg = {
            key = "B924 244C A7E6 6DB4 7386 7B7C FE39 AAD9 091A 1CD7";
            signByDefault = true;
          };
          imap = {
            host = "nextmail.alembiq.net";
            port = 993;
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          notmuch.enable = true;
          primary = false;
          signature = {
            text = ''

              Karel Ochman
              karel@ochman.info
              +420 777 123 644

            '';
            showSignature = "append";
          };
          passwordCommand = "${pkgs.coreutils}/bin/cat /run/user/1111/secrets/charles/email/ochman";
          smtp = {
            host = "nextmail.alembiq.net";
          };
        };
        accounts."karel.kremel@snempohanskychobci.org" = {
          neomutt = {
            enable = true;
            extraConfig = ''
              mailboxes /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Inbox /home/charles/Maildir/karel.kremel@snempohanskychobci.org/INBOX@INFO /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Drafts /home/charles/Maildir/karel.kremel@snempohanskychobci.org/ACCESS /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Sent /home/charles/Maildir/karel.kremel@snempohanskychobci.org/SENT@INFO /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Junk /home/charles/Maildir/karel.kremel@snempohanskychobci.org/JUNK@INFO /home/charles/Maildir/karel.kremel@snempohanskychobci.org/Trash
              named-mailboxes @snempohanskychobci.org +Inbox
              folder-hook . "set sort=date ; set sort_aux=thread"
            '';
          };
          realName = "Karel Křemel | Sněm pohanských obcí";
          address = "karel.kremel@snempohanskychobci.org";
          userName = "karel.kremel@snempohanskychobci.org";
          gpg = {
            key = "4A72D7FD235E50F93F6801A005F6EFFABE002CB2";
            signByDefault = true;
          };
          imap = {
            host = "nextmail.alembiq.net";
            port = 993;
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          notmuch.enable = true;
          primary = false;
          signature = {
            text = ''

              Karel Křemel
              karel.kremel@snempohanskychobci.org
              www.snempohanskychobci.org

            '';
            showSignature = "append";
          };
          passwordCommand = "${pkgs.coreutils}/bin/cat /run/user/1111/secrets/charles/email/snempohanskychobci"; # FIXME dynamic UID, sops
          smtp = {
            host = "nextmail.alembiq.net";
          };
        };
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
        ssh = {
          enable = true;
          matchBlocks = {
            net = {
              forwardAgent = true;
              remoteForwards = [
                {
                  bind.address = "/%d/.gnupg-sockets/S.gpg-agent";
                  host.address = "/%d/.gnupg-sockets/S.gpg-agent.extra";
                }
              ];
            };

            ## REMOTE SYSTEMS
            "bitbucket.org" = {
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "karelkremel";
            };
            "brokkr brokkr.alembiq.net" = {
              hostname = "37.205.11.47";
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "root";
              forwardAgent = true;
            };
            "eir eir.alembiq.net" = {
              hostname = "37.205.14.77";
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "charles";
              forwardAgent = true;
              extraOptions = {
                StreamLocalBindUnlink = "true";
                RemoteForward = "/run/user/1111/gnupg/S.gpg-agent /run/user/1111/gnupg/S.gpg-agent.extra";
                # RemoteForward = "/run/user/1111/gnupg/S.gpg-agent.ssh /run/user/1111/gnupg/S.gpg-agent.ssh";
              };
            };
            "forge.*" = {
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "root";
              forwardAgent = true;
            };
            "forge.svornosti" = {
              hostname = "10.0.42.153";
            };
            "github.com" = {
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "alembiq";
            };
            "gitlab.com" = {
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "alembiq";
            };
            "nextmail nextmail.alembiq.net" = {
              hostname = "37.205.13.138";
            };
            ## HOME NETWORK
            "badb-wlan badb-wlan.svornosti" = {
              hostname = "10.0.42.111";
            };
            "fileserver fileserver.svornosti" = {
              hostname = "10.0.42.208";
            };
            "fw fw.alembiq.net" = {
              hostname = "tyr.alembiq.net";
              user = "root";
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              forwardAgent = true;
              port = 60001;
            };
            "fw.svornosti" = {
              hostname = "10.0.42.254";
              user = "root";
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              forwardAgent = true;
              port = 60001;
            };
            "gitlab gitlab.svornosti gitlab.alembiq.net" = {
              hostname = "10.0.42.204";
            };
            # "hekate-lan hekate-lan.svornosti" = {
            #     hostname = "10.0.42.102";
            # };
            # "hekate-wlan hekate-wlan.svornosti" = {
            #     hostname = "10.0.43.102";
            # };
            "jellyfin jellyfin.svornosti" = {
              hostname = "10.0.42.207";
              user = "ansible";
            };
            "kubera-lan kubera-lan.svornosti" = {
              hostname = "10.0.42.250";
            };
            "arm-ripper.svornosti" = {
              hostname = "kubera-lan.svornosti";
              localForwards = [
                {
                  bind.port = 8888;
                  host.address = "172.17.0.2";
                  host.port = 8080;
                }
              ];
            };
            "nextcloud nextcloud.svornosti cloud.ochman.info" = {
              hostname = "10.0.42.203";
              user = "ansible";
            };
            "octopi.svornosti" = {
              hostname = "10.0.42.232";
            };
            "pihole.svornosti" = {
              hostname = "10.0.42.253";
              user = "ansible";
            };
            "pikvm.svornosti" = {
              hostname = "10.0.42.249";
              user = "root";
            };

            # "verdandi-lan verdandi-lan.svornosti" = {
            #     hostname = "10.0.42.101";
            # };
            # "verdandi-wlan verdandi-wlan.svornosti" = {
            #     hostname = "10.0.43.101";
            # };
            "10.0.4?.* *.svornosti" = {
              # *.tailscale
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              forwardAgent = true;
            };
            "jellyfin* nextcloud* pihole*" = {
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "ansible";
              forwardAgent = true;
              # proxyJump = "tyr";
            };
            "verdandi* badb* fileserver hekate* kubera* octopi* pine* gitlab.svornosti gitlab gitlab.alembiq.net" = {
              identityFile = "~/.ssh/YUBI-KK2024.pub";
              user = "charles";
              forwardAgent = true;
              # proxyJump = "tyr";
            };
            # "lancre" = {
            #     hostname = "lancre.tail52316.ts.net";
            #     identityFile = "~/.ssh/YUBI-KK2024.pub";
            #     user = "charles";
            # };
            ## GENERAL
            "*" = {
              addressFamily = "inet";
              forwardX11 = false;
              forwardX11Trusted = false;
            };
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
