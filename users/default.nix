{
  pkgs,
  lib,
  options,
  config,
  ...
}:

{
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  programs = {
    # home-manager.users.<name>.programs
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      profileExtra = "gpgconf --launch gpg-agent";
      historyFileSize = -1;
      historySize = -1;
      historyIgnore = [
        "ls"
        "cd"
        "exit"
      ];
      historyControl = [ "erasedups" ];
      sessionVariables = {
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_DESKTOP_DIR = "$HOME";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_SESSION_TYPE = "wayland";

        MOZ_ENABLE_WAYLAND = 1; # Firefox Wayland
        MOZ_DBUS_REMOTE = 1; # Firefox wayland
        GDK_BACKEND = "wayland";
        NIXOS_OZONE_WL = "1"; # Hint Electon apps to use wayland
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";

        # nix-shell -p xdg-ninja
        HISTFILE = "$HOME/.local/state/bash/history";
        CARGO_HOME = "$HOME/.local/share/cargo";
        XCOMPOSECACHE = "$HOME/.cache/X11/xcompose";
        W3M_DIR = "$HOME/.local/share/w3m";
      };
    };
    gpg = {
      # https://github.com/drduh/YubiKey-Guide/blob/b57c7f7901f6d748d35c84a96609a64aa2301e50/flake.nix
      settings = {
        # https://home-manager-options.extranix.com/?query=program.gpg
        cert-digest-algo = "SHA512";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        charset = "utf-8";
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        no-symkey-cache = true;
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        require-cross-certification = true;
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        throw-keyids = true;
        use-agent = true;
        verify-options = "show-uid-validity";
        with-fingerprint = true;
      };
      enable = true;
    };
    ssh = {
      addKeysToAgent = "no";
      controlMaster = "auto";
      controlPath = "~/.ssh/master-%r@%h:%p";
      controlPersist = "60";
      enable = true;
      extraConfig = ''
        ChallengeResponseAuthentication no
        StrictHostKeyChecking ask
        VerifyHostKeyDNS ask
        Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
        MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
        KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
        HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
      '';
      hashKnownHosts = true;
      serverAliveCountMax = 30;
      serverAliveInterval = 300;
    };
  }; # END of home-manager.users.<name>.programs

  services = {
    # home-manager.users.<name>.services
    gpg-agent = {
      defaultCacheTtl = 60;
      enable = true;
      enableBashIntegration = true;
      enableScDaemon = true;
      enableSshSupport = true;
      extraConfig = ''
        ttyname $GPG_TTY
        allow-preset-passphrase
      '';
      maxCacheTtl = 120;
      # pinentryPackage = lib.mkForce pkgs.pinentry-qt;
      enableExtraSocket = true;
    };
    ssh-agent.enable = false;
  }; # END of home-manager.users.<name>.services

}
