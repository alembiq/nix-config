{ pkgs, config, ... }:
{
  home-manager.users.charles.programs.ssh = {
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
      #  ______     _____  ____  _   _  ___  ____ _____ ___
      # / ___\ \   / / _ \|  _ \| \ | |/ _ \/ ___|_   _|_ _|
      # \___ \\ \ / / | | | |_) |  \| | | | \___ \ | |  | |
      #  ___) |\ V /| |_| |  _ <| |\  | |_| |___) || |  | |
      # |____/  \_/  \___/|_| \_\_| \_|\___/|____/ |_| |___|
      # "hekate hekate.svornosti" = {
      #     hostname = "10.0.42.102";
      # };
      "fw.svornosti omnia-svornosti" = {
        user = "root";
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        forwardAgent = true;
        port = 60001;
      };
      "fw.svornosti" = {
        hostname = "10.0.42.254";
      };
      "badb badb.svornosti badb.svornosti-jump" = {
        hostname = "10.0.42.111";
      };
      "gitlab gitlab.svornosti gitlab.svornosti-jump" = {
        # gitlab.alembiq.net
        hostname = "10.0.42.204";
      };
      "kubera.svornosti kubera.svornosti-jump" = {
        # kubera
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
      "octopi.svornosti octopi.svornosti-jump" = {
        hostname = "10.0.42.232";
      };
      "pikvm.svornosti pivkm.svornosti-jump" = {
        hostname = "10.0.42.249";
        user = "root";
      };
      "verdandi.svornosti verdandi.svornosti-jump" = {
        hostname = "10.0.42.101";
      };
      "nextcloud nextcloud.svornosti nextcloud.svornosti-jump" = {
        hostname = "10.0.42.203";
      };
      "jellyfin jellyfin.svornosti jellyfin.svornosti-jump" = {
        hostname = "10.0.42.202";
      };
      "jellyfin.* nextcloud.* cloud.ochman.info " = {
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        user = "ansible";
        forwardAgent = true;
      };
      "10.0.4?.* *.svornosti *.svornosti-jump" = {
        identityFile = "~/.ssh/YUBI-KK2024.pub";
        forwardAgent = true;
      };
      "10.0.4?.* *.svornosti-jump" = {
        proxyJump = "omnia-svornosti";
      };
      "verdandi* badb* fileserver hekate* kubera* octopi* pine* gitlab.svornosti gitlab gitlab.alembiq.net" = {
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
      #   ____ _____ _   _ _____ ____      _    _
      #  / ___| ____| \ | | ____|  _ \    / \  | |
      # | |  _|  _| |  \| |  _| | |_) |  / _ \ | |
      # | |_| | |___| |\  | |___|  _ <  / ___ \| |___
      #  \____|_____|_| \_|_____|_| \_\/_/   \_\_____|
      "*" = {
        addressFamily = "inet";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
    };
  };
}
