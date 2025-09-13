{ pkgs, config, ... }:
{
  home-manager.users.charles.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      net = {
        remoteForwards = [
          {
            bind.address = "/%d/.gnupg-sockets/S.gpg-agent";
            host.address = "/%d/.gnupg-sockets/S.gpg-agent.extra";
          }
        ];
      };
      #  ____  _____ __  __  ___ _____ _____
      # |  _ \| ____|  \/  |/ _ \_   _| ____|
      # | |_) |  _| | |\/| | | | || | |  _|
      # |  _ <| |___| |  | | |_| || | | |___
      # |_| \_\_____|_|  |_|\___/ |_| |_____|
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
        };
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
      #  ______     _____  ____  _   _  ___  ____ _____ ___
      # / ___\ \   / / _ \|  _ \| \ | |/ _ \/ ___|_   _|_ _|
      # \___ \\ \ / / | | | |_) |  \| | | | \___ \ | |  | |
      #  ___) |\ V /| |_| |  _ <| |\  | |_| |___) || |  | |
      # |____/  \_/  \___/|_| \_\_| \_|\___/|____/ |_| |___|
      "fw.svornosti omnia-svornosti" = {
        user = "root";
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        forwardAgent = true;
        port = 60001;
      };
      "fw.svornosti" = {
        hostname = "10.0.42.254";
      };
      "badb badb.*" = {
        user = "root";
        forwardAgent = true;
      };
      "badb.*" = {
        hostname = "10.0.42.107";
      };
      "hanuman hanuman.*" = {
        user = "karel";
        forwardAgent = true;
      };
      "hanuman.*" = {
        hostname = "10.0.42.102";
      };

      "gitlab gitlab.svornosti" = {
        hostname = "10.0.42.204";
      };
      "kubera.svornosti kubera.svornosti-jump" = {
        hostname = "10.0.42.250";
      };
      "arm-ripper.svornosti" = {
        hostname = "10.0.42.250";
        extraOptions = {
          "RemoteCommand" = "docker exec -it arm-rippers bash";
          "RequestTTY" = "yes";
        };
        localForwards = [
          {
            bind.port = 8888;
            host.address = "172.17.0.2";
            host.port = 8080;
          }
        ];
      };
      "octopi.*" = {
        hostname = "10.0.42.232";
      };
      "pikvm.*" = {
        hostname = "10.0.42.249";
        user = "root";
      };
      "verdandi.*" = {
        hostname = "10.0.42.101";
      };
      "nextcloud nextcloud.*" = {
        hostname = "10.0.42.203";
      };
      "jellyfin jellyfin.*" = {
        hostname = "10.0.42.202";
      };
      "jellyfin jellyfin.* nextcloud nextcloud.*" = {
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        user = "ansible";
        forwardAgent = true;
      };
      "10.0.4?.* *.svornosti *.svornosti-jump !worldbuilding" = {
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        forwardAgent = true;
      };
      "10.0.4?.* *.svornosti-jump" = {
        proxyJump = "omnia-svornosti";
      };
      "hanuman hanuman.* verdandi verdandi.* kubera kubera.* octopi octopi.* gitlab gitlab.svornosti gitlab.alembiq.net" =
        {
          # waiting for user charles on badb badb.* "
          identityFile = "~/.ssh/YUBI-KK2024.pub";
          user = "charles";
          forwardAgent = true;
        };
      #  ____  ____  _   _  ___
      # | __ )|  _ \| \ | |/ _ \
      # |  _ \| |_) |  \| | | | |
      # | |_) |  _ <| |\  | |_| |
      # |____/|_| \_\_| \_|\___/
      "fw.brno omnia-brno" = {
        user = "root";
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        forwardAgent = true;
        localForwards = [
          {
            bind.port = 8080;
            host.address = "10.0.52.253";
            host.port = 80;
          }
        ];
      };
      "fw.brno" = {
        hostname = "10.0.52.254";
      };
      "10.0.5?.* *.brno *.brno-jump" = {
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        forwardAgent = true;
      };
      "10.0.5?.* *.brno-jump" = {
        proxyJump = "omnia-brno";
      };
      #   ___ _____ _   _ _____ ____
      #  / _ \_   _| | | | ____|  _ \
      # | | | || | | |_| |  _| | |_) |
      # | |_| || | |  _  | |___|  _ <
      #  \___/ |_| |_| |_|_____|_| \_\
      "lancre" = {
        hostname = "lancre.tail52316.ts.net";
        user = "charles";
        identityFile = "~/.ssh/YUBI-KK2025.pub";
        forwardAgent = true;
      };
      "forge" = {
        hostname = "forge.tail752f90.ts.net";
        identityFile = "~/.ssh/YUBI-KK2025.pub";
        user = "root";
        forwardAgent = true;
      };

      #   ____ _____ _   _ _____ ____      _    _
      #  / ___| ____| \ | | ____|  _ \    / \  | |
      # | |  _|  _| |  \| |  _| | |_) |  / _ \ | |
      # | |_| | |___| |\  | |___|  _ <  / ___ \| |___
      #  \____|_____|_| \_|_____|_| \_\/_/   \_\_____|
      "*" = {
        addressFamily = "inet";
        forwardX11 = false;
        forwardX11Trusted = false;
        addKeysToAgent = "no";
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%h:%p";
        controlPersist = "60";
        hashKnownHosts = true;
        serverAliveCountMax = 30;
        serverAliveInterval = 300;
        extraOptions = {
          "ChallengeResponseAuthentication" = "no";
          "StrictHostKeyChecking" = "ask";
          "VerifyHostKeyDNS" = "ask";
          "Ciphers" = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com";
          "MACs" = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com";
          "KexAlgorithms" = "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256";
          "HostKeyAlgorithms" =
            "ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa";
        };
      };
    };
  };
}
