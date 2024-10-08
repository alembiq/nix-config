{ pkgs, config, lib, ... }:
let
    ungoogled-chromium = pkgs.ungoogled-chromium.override {
        enableWideVine = true;
    };
in
{
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
        spotify-player
        element-desktop
        beeper #https://help.beeper.com/en_US/troubleshooting/beeper-on-linux-crashing
        obsidian
        morgen
        element-desktop
        netscanner nmap arp-scan
        mc
        vlc #jdk21
        wlprop
        ungoogled-chromium
        libreoffice # onlyoffice-bin has problems with clipboard under wayland
        xfce.thunar xfce.thunar-archive-plugin xfce.thunar-volman xfce.tumbler
        rpi-imager
        okular
        xdg-utils nwg-displays
    ];

    xdg.mimeApps = {
        enable = true;
            defaultApplications = {
            "application/vnd.oasis.opendocument.text" = "writer.desktop";
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
            "application/pdf" ="okularApplication_pdf.desktop";
            "x-scheme-handler/element" = "element-desktop.desktop";
            "text/html" = "firefox.desktop";
            "text/plain" =" codium.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
            "x-scheme-handler/about" = "firefox.desktop";
            "x-scheme-handler/unknown" = "firefox.desktop";
            "application/xhtml+xml" = "firefox.desktop";
            "x-scheme-handler/morgen" = "morgen.desktop";
            "application/vnd.oasis.opendocument.spreadsheet" =" onlyoffice-desktopeditors.desktop";
        };
    }; #END of home-manager.users.charles.xdg

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

}
