{ config, lib, pkgs, modulesPath, nixos-hardware, ... }@inputs:
let
    vlc = pkgs.vlc.override {
        libbluray = pkgs.libbluray.override {
            withJava = true;
            withAACS = true;
            withBDplus = true;
        };
    };
    ungoogled-chromium = pkgs.ungoogled-chromium.override {
        enableWideVine = true;
    };
# db for libaacs: http://www.videolan.org/developers/libaacs.html
# mkdir -p ~/.config/aacs
# (
# 	cd ~/.config/aacs
# 	wget http://www.labdv.com/aacs/KEYDB.cfg
# )
in
{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.disko.nixosModules.default
        ./default.nix
        ../modules/nixos/remotebuilder.nix
        ../users/charles.nix
        ../users/backup.nix
        ./verdandi-disko.nix
        ../modules/nixos/hyprland.nix
        ../modules/nixos/sway.nix
        ../modules/nixos/stylix.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    ];

    sops = {
        age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        defaultSopsFile = ../secrets/wifi.yaml ;
                secrets = {
                    "wifi" = {
                        # owner = "user";
                        # path = "/etc/file";
                    };
                };
    }; #END of SOPS

    security = {
        sudo.wheelNeedsPassword = false;
    };

    environment.etc."greetd/environments".text = ''
        Hyprland
        sway
        bash
    '';

    system.activationScripts = {
        msmtp = { #FIXME folder MSMTP not using
            text = ''
                mkdir -p /home/charles/.local/share/msmtp
                chown charles /home/charles/.local/share/msmtp
                chmod 700 /home/charles/.local/share/msmtp
            '';
        };
    };


    home-manager = {
        # TODO Notmuch
        users.charles = {
            stylix = { #FIXME stylix ignoring targers; missing chromium, firefox, vscode, pinentry
                base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml"; # https://raw.githubusercontent.com/ada-lovecraft/base16-nord-scheme/master/nord.yaml
                polarity = "dark";
                autoEnable = true;
                targets.firefox.enable = true;
                targets.gtk.enable = true;
                targets.hyprland.enable = true;
                targets.sway.enable = true;
                targets.swaylock.enable = true;
                targets.vscode.enable = true;
                targets.waybar.enable = false;
                targets.wezterm.enable = false;
                targets.wpaperd.enable = true;
                targets.xresources.enable = true;
            };

            imports = [
            ../modules/homemanager/mail.nix
            ../modules/homemanager/waybar.nix
            ../modules/homemanager/hyprland.nix
            ../modules/homemanager/hyprlock.nix
            ../modules/homemanager/hypridle.nix
            ../modules/homemanager/wezterm.nix
            ../modules/homemanager/firefox.nix
            ../modules/homemanager/nextcloud.nix
            ../modules/homemanager/vscodium.nix
            ../modules/homemanager/sway.nix
            ../modules/homemanager/wofi.nix
            ];
            sops = {
                # https://github.com/Mic92/sops-nix?tab=readme-ov-file#Flakes
                # https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/#sops-nix
                gnupg.home = "/home/charles/.gnupg"; #FIXME dynamic user
                #FIXME sops import host keys
                #FIXME sops multiple PIN entry
                #FIXME sops not initiated in CLI
                defaultSopsFile = ../users/charles.yaml ;
                secrets = {
                    "charles/email/gmail" = { };
                    "charles/email/karelkremel" = { };
                    "charles/email/alembiq" = { };
                    "charles/email/ochman" = {  };
                    "charles/email/snempohanskychobci" = { };
                    "charles/nextcloud" = { };
                    "charles/svornosti/fileserver/samba" = { };
                };
            }; #END of home-manager.users.charles.sops
            gtk = {
                enable = true;
                iconTheme = {
                    name = "Nordzy-dark";
                    package = pkgs.nordzy-icon-theme;
                };
            };
            xdg.mimeApps = {
              enable = true;
                  defaultApplications = {
                    "x-scheme-handler/element" = "element-desktop.desktop";
                    "text/html" = "firefox.desktop";
                    "x-scheme-handler/http" = "firefox.desktop";
                    "x-scheme-handler/https" = "firefox.desktop";
                    "x-scheme-handler/about" = "firefox.desktop";
                    "x-scheme-handler/unknown" = "firefox.desktop";
                    "application/xhtml+xml" = "firefox.desktop";
                    "x-scheme-handler/morgen" = "morgen.desktop";
                    "application/rtf" = "writer.desktop";
                };
            }; #END of home-manager.users.charles.xdg

            # home.file = { #FIXME symlink create with relative path
            #     "Documents".target = "./nextcloud/Documents";
            #     "Documents".target = builtins.toString "/home/charles/nextcloud/Documents";
            #     Pictures.source = builtins.toPath "/home/charles/nextcloud/Pictures";
            #     Documents.source = file.mkOutOfStoreSymlink "/home/charles/nextcloud/Documents";
            #     Documents.target = builtins.toString "nextcloud/Documents";
            # };
            xdg.userDirs.documents = "${config.home.homeDirectory}/nextcloud/Documents";
            xdg.userDirs.pictures = "${config.home.homeDirectory}/nextcloud/Pictures";
            # home.activation.linkMyStuff = ''
            #   ln -sf $HOME/nextcloud/Documents $HOME.Documents;
            #   ln -sf $HOME/nextcloud/Pictures $HOME.Pictures;
            # '';

            systemd.user = {
                startServices = true;
                sockets.yubikey-touch-detector = {
                    Unit.Description = "Unix socket activation for YubiKey touch detector service";
                    Socket = {
                        ListenStream = "%t/yubikey-touch-detector.socket";
                        RemoveOnStop = true;
                    };
                    Install.WantedBy = [ "sockets.target" ];
                };
                services.yubikey-touch-detector = {
                    Unit = {
                        Description = "Detects when your YubiKey is waiting for a touch";
                        Requires = "yubikey-touch-detector.socket";
                    };
                    Service = {
                        ExecStart = "${lib.getExe pkgs.yubikey-touch-detector} --libnotify";
                        EnvironmentFile = "-%E/yubikey-touch-detector/service.conf";
                    };
                    Install = {
                        Also = "yubikey-touch-detector.socket";
                        WantedBy = [ "default.target" ];
                    };
                };
                # Link /run/user/$UID/gnupg to ~/.gnupg-sockets
                # So that SSH config does not have to know the UID
                #FIXME dynamic user, UID
                services.link-gnupg-sockets = {
                    Unit = {
                        Description = "link gnupg sockets from /run to /home";
                    };
                    Service = {
                        Type = "oneshot";
                        ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/1111/gnupg /home/charles/.gnupg-sockets";
                        ExecStop = "${pkgs.coreutils}/bin/rm /home/charles/.gnupg-sockets";
                        RemainAfterExit = true;
                    };
                    Install.WantedBy = [ "default.target" ];
                };
            }; #END of home-manager.users.charles.systemd.user
            home = {
                packages = with pkgs; [
                    prusa-slicer
                    openscad-unstable
                    calibre
                    spotify-player
                    element-desktop
                    beeper #https://help.beeper.com/en_US/troubleshooting/beeper-on-linux-crashing
                    obsidian
                    morgen
                    element-desktop
                    nmap
                    poppler_utils #pdf tools
                    mc
                    vlc #jdk21
                    wlprop
                    overskride blueberry # blueman
                    ungoogled-chromium
                    deluge
                    onlyoffice-bin libreoffice #TODO choose office
                    # makemkv handbrake libaacs libbluray libdvdcss
                    warp-terminal wezterm
                    xfce.thunar
                    rpi-imager
                    mate.atril # vs okular
                    direnv
                ];
                stateVersion = "23.11";
            }; #END of home-manager.users.charles.home
        }; #END of home-manager.users.charles
    }; #END of home-manager



    #TODO docker
    #TODO new kernel
    #TODO 4G modem
    #TODO fingerprint
    #TODO NFC
    #TODO hibernate
    powerManagement.enable = true;
    powerManagement.powertop.enable = true;
    systemd.services.ModemManager.enable = true;

    services = {
        greetd = {
            enable = true;
            # restart = false;
            settings = {
                default_session = {
                    command = ''
                        ${pkgs.greetd.tuigreet}/bin/tuigreet -r --asterisks --time \
                        --cmd Hyprland
                    '';
                };
                user = "charles";
            };
        };
        power-profiles-daemon.enable = false; # needed to enable TLP
        pcscd.enable = true;
        udev.packages = with pkgs; [yubikey-personalization libu2f-host];
        pipewire = {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = true;
            wireplumber.enable = true;
        };
        xserver = {
            enable = true;
        };
        deluge.config = ''{
            download_location = "/srv/torrents/";
        }'';
        auto-cpufreq = {
            enable = true;
            settings = {
                battery = {
                    governor = "powersave";
                    turbo = "never";
                };
                charger = {
                    governor = "performance";
                    turbo = "auto";
                };
            };
        };
        system76-scheduler.settings.cfsProfiles.enable = true;
        tlp = {
            enable = true;
            settings = {
                CPU_SCALING_GOVERNOR_ON_AC = "performance";
                CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

                CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
                CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

                CPU_MIN_PERF_ON_AC = 0;
                CPU_MAX_PERF_ON_AC = 100;
                CPU_MIN_PERF_ON_BAT = 0;
                CPU_MAX_PERF_ON_BAT = 50;

                START_CHARGE_THRESH_BAT0 = 40;
                STOP_CHARGE_THRESH_BAT0 = 80;
            };
        };
        zfs = {
            trim.enable = true;
            autoScrub.enable = true;
        };
        sanoid = {
            enable = true;
            interval = "*:2,32";
            templates.backup = {
                hourly = 36;
                daily = 14;
                weekly = 0;
                monthly = 0;
                yearly = 0;
                autoprune = true;
                autosnap = true;
            };
            templates.day = {
                hourly = 0;
                daily = 7;
                weekly = 0;
                monthly = 0;
                yearly = 0;
                autoprune = true;
                autosnap = true;
            };
            templates.rotate = {
                autoprune = true;
                autosnap = true;
                hourly = 1;
                daily = 1;
                weekly = 1;
                monthly = 0;
                yearly = 0;
            };
            datasets."zpool/home/charles" = {
                useTemplate = [ "backup" ];
            };
            datasets."zpool/nixos/etc" = {
                useTemplate = [ "backup" ];
            };
            datasets."zpool/nixos" = {
                useTemplate = [ "day" ];
            };
            datasets."zpool/home/charles/mail" = {
                useTemplate = [ "rotate" ];
            };
           datasets."zpool/home/charles/cache" = {
               useTemplate = [ "rotate" ];
           };
           datasets."zpool/home/charles/torrent" = {
               useTemplate = [ "rotate" ];
           };
            datasets."zpool/home/charles/nextcloud" = {
                useTemplate = [ "rotate" ];
            };
        };
        syncoid = { #FIXME do pull insted of push
            user = "backup";
            enable = true;
            interval =  "*:35";
            commonArgs = ["--no-sync-snap" "--debug"]; #
            commands = {
                "nixos" = {
                    source = "zpool/nixos/etc";
                    target = "backup@100.118.57.39:tank/vault/localhost-verdandi/20240325_nixos";
                    sendOptions = "w c";
                    #TODO syncoid path and the key /var/lib/syncoid/id_ed25519 ? user backup
                    sshKey = "/var/lib/syncoid/id_ed25519";
                    extraArgs = [ "--sshoption=StrictHostKeyChecking=off" "--recursive" ];
                };
                "home" = {
                    source = "zpool/home/charles";
                    target = "backup@100.118.57.39:tank/vault/localhost-verdandi/20240325_charles";
                    sendOptions = "w c";
                    sshKey = "/var/lib/syncoid/id_ed25519";
                    extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
                };
            # FIXME syncoid SENDER needs `zfs allow backup create,receive,destroy,rollback,snapshot,hold,release,mount zroot`
            # RECEIVER needs zfs allow backup receive,mount,create
            };
        };
    }; #END of services

    programs = {
        yubikey-touch-detector.enable = true;
        steam = {
            enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

        };
    }; #END of programs

    environment = {
        sessionVariables = {
            NIXOS_OZONE_WL = "1"; # Hint Electon apps to use wayland
            QT_QPA_PLATFORM = "wayland";
            MOZ_ENABLE_WAYLAND = "1";
            XDG_SESSION_TYPE = "wayland";
            SDL_VIDEODRIVER = "wayland";
        };
        systemPackages = with pkgs; [
            vscodium
            btrfs-progs
            powertop
            ipcalc
            wget
            lm_sensors
            easyeffects pavucontrol #alternatives qpwgraph ncpamixer helvum
            libu2f-host
            yubikey-personalization
            yubikey-personalization-gui
            yubikey-manager
            yubikey-touch-detector
            cifs-utils
        ];
    };

    sound.enable = true;
    hardware = {
        gpgSmartcards.enable = true;
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        bluetooth.enable = true; #TODO paired BT deviced
        graphics = {
            enable = true;
            enable32Bit = true;
        };
    };

    # https://nixos.wiki/wiki/Fonts
    fonts.packages = with pkgs; [
        fira-code
        fira-code-nerdfont
    ];

    security = {
        rtkit.enable = true;
        pam.services = {
            greetd.enableGnomeKeyring = true;
            hyprlock = {}; # to enable hyprlock auth
        };
    };


    # security.pam = {
    #     yubico = { #nix-shell --command 'ykinfo -s' -p yubikey-personalization
    #         enable = true;
    #         # debug = true;
    #         mode = "challenge-response";
    #         # id = [
    #         #     "19937800" #KK2023
    #         #     "23126686" #KK2024NANO
    #         #     ];
    #     };
    #     u2f.enable = true;
    #     services = {
    #         login.u2fAuth = true;
    #         sudo.u2fAuth = true;
    #         swaylock = {};
    #     };
    # };

    fileSystems."/mnt/media" = {
        device = "//10.0.42.208/media";
        fsType = "cifs";
        options = let
            automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
        in
            ["${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"];
        # FIXME dynamic GID, UID, sops
    };
    fileSystems."/mnt/video" = {
        device = "//10.0.42.208/video";
        fsType = "cifs";
        options = let
            automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
        in
            ["${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"];
        # FIXME dynamic GID, UID, sops
    };
    fileSystems."/mnt/library" = {
        device = "//10.0.42.208/library";
        fsType = "cifs";
        options = let
            automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
        in
            ["${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"];
        # FIXME dynamic GID, UID, sops
    };
    fileSystems."/mnt/audio" = {
        device = "//10.0.42.208/audio";
        fsType = "cifs";
        options = let
            automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
        in
            ["${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"];
        # FIXME dynamic GID, UID, sops
    };
    fileSystems."/mnt/vault" = {
        device = "//10.0.42.208/vault";
        fsType = "cifs";
        options = let
            automount_opts = "_netdev,x-system.requires=network.targer,x-systemd.automount,noauto,x-systemd.idle-timeout=15s,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,vers=3.1.1,user";
        in
            ["${automount_opts},credentials=/run/user/1111/secrets/charles/svornosti/fileserver/samba,uid=1111,gid=100"];
        # FIXME dynamic GID, UID, sops
    };



    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
    };
    systemd.sleep.extraConfig = ''
        AllowSuspend=yes
        AllowHibernation=yes
        AllowHybridSleep=yes
        AllowSuspendThenHibernate=yes
    '';


    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 20;
    boot.loader.systemd-boot.consoleMode = "auto"; #FIXME same console size everywhere - systemd-bootd limitation :(
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "uas" "sd_mod" ];
    boot.kernelModules = [ "kvm-intel" ];
    # https://github.com/NixOS/nixpkgs/issues/219239
    boot.initrd.kernelModules = ["i915"];
    boot.kernelParams = [ "mitigations=off" "i915.enable_psr=0" "i915.enable_fbc=1" "i915.fastboot=0" "i915.enable_dc=0" "i915.enable_guc=3" ]; #fastboot=0
    boot.extraModulePackages = [ ];
    networking = {
        hostId = "cf4e3181";
        hostName = "verdandi";
        networkmanager.enable = true;
# nmcli con show
# nmcli con modify HotelWifiName wifi.cloned-mac-address 70:48:f7:1a:2b:3c
# nmcli device disconnect wlp0s20f3
# nmcli device connect wlp0s20f3
        useDHCP = lib.mkDefault true;
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
