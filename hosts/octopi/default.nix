# https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux
# https://github.com/mcdonc/nixos-pi-zero-2/tree/main

{
  config,
  pkgs,
  lib,
  nixos-hardware,
  ...
}:

let
  user = "guest";
  password = "guest";
  SSID = "ALEMBIQ.net";
  SSIDpassword = "**********";
  interface = "wlan0";
  hostname = "octopi";

  python_with_packages = (
    pkgs.python311.withPackages (
      p: with p; [
        pkgs.python311Packages.rpi-gpio
        pkgs.python311Packages.gpiozero
        pkgs.python311Packages.pyserial
        pkgs.python311Packages.pip
      ]
    )
  );

in
{
  documentation.nixos.enable = false;
  imports = [ nixos-hardware.nixosModules.raspberry-pi-4 ];

  services.zram-generator = {
    enable = true;
    settings.zram0 = {
      compression-algorithm = "zstd";
      zram-size = "ram * 2";
    };
  };

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  environment.systemPackages = with pkgs; [
    v4l-utils
    git
    libraspberrypi
    raspberrypi-eeprom
    tree
    htop
    zlib
    cmake
    xdotool
    imagemagick
    python_with_packages
    octoprint
  ];

  nixpkgs.overlays = [
    (self: super: {
      octoprint = super.octoprint.override {
        packageOverrides = pyself: pysuper: {
          camerasettings = pyself.buildPythonPackage rec {
            # FIXME needs v3l-tools and updated paths
            pname = "CameraSettings";
            version = "0.4.3";
            src = self.fetchFromGitHub {
              owner = "The-EG";
              repo = "OctoPrint-CameraSettings";
              rev = "${version}";
              sha256 = "sha256-VGSlJzWYIpqBe0xe5UG6+BIveR3nfC3F/FLnSd09fH4=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          bgcode = pyself.buildPythonPackage rec {
            # FIXME needs zlib and cmake and updated paths
            pname = "BGCode";
            version = "0.2.0";
            src = self.fetchFromGitHub {
              owner = "jneilliii";
              repo = "OctoPrint-BGCode";
              rev = "${version}";
              sha256 = "sha256-LHK1LfYXAQV2GvWfG6AFf9haU9zcCP/fZB2UwKbm1i4=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          cancelobject = pyself.buildPythonPackage rec {
            pname = "Cancelobject";
            version = "0.5.0";
            src = self.fetchFromGitHub {
              owner = "paukstelis";
              repo = "OctoPrint-Cancelobject";
              rev = "${version}";
              sha256 = "sha256-I/uhkUO2ajgo0b9SZH6j6w1s4GoDuh1V3owPuiiFr9A=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          prusaresetmode = pyself.buildPythonPackage rec {
            pname = "PrusaResetMode";
            version = "0.1.1";
            src = self.fetchFromGitHub {
              owner = "jacopotediosi";
              repo = "Octoprint-PrusaResetMode";
              rev = "v${version}";
              sha256 = "sha256-VaIO0pv5ZBaTj20qRmNtLX1UVwt8ZXQzOwbAP/qIY20=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          resourcemonitor = pyself.buildPythonPackage rec {
            pname = "OctoPrint-Resource-Monitor";
            version = "0.3.16";
            src = self.fetchFromGitHub {
              owner = "Renaud11232";
              repo = "OctoPrint-Resource-Monitor";
              rev = "${version}";
              sha256 = "sha256-7/xYcWiGTF089JshybYTF6cViFAkR59939FCZ4gPh7w=";
              #TODO update
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          slicerestimator = pyself.buildPythonPackage rec {
            pname = "SlicerEstimator";
            version = "1.6.4";
            src = self.fetchFromGitHub {
              owner = "NilsRo";
              repo = "OctoPrint-SlicerEstimator";
              rev = "${version}";
              sha256 = "sha256-vOAo8I20JzuQgkaypgIxf0Im5wxVyGVAZ959thjC1vI=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };

          prusaslicerthumbnails = pyself.buildPythonPackage rec {
            # FIXME needs xdotool imagemagick and  updated paths
            pname = "PrusaSlicerThumbnails";
            version = "1.0.7";
            src = self.fetchFromGitHub {
              owner = "jneilliii";
              repo = "OctoPrint-PrusaSlicerThumbnails";
              rev = "${version}";
              sha256 = "sha256-waNCTjAZwdBfhHyJCG2La7KTnJ8MDVuX1JLetFB5bS4=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          firmwareupdater = pyself.buildPythonPackage rec {
            pname = "FirmwareUpdater";
            version = "1.14.0";
            src = self.fetchFromGitHub {
              owner = "OctoPrint";
              repo = "OctoPrint-FirmwareUpdater";
              rev = "${version}";
              sha256 = "sha256-CUNjM/IJJS/lqccZ2B0mDOzv3k8AgmDreA/X9wNJ7iY=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          widescreen = pyself.buildPythonPackage rec {
            pname = "WideScreen";
            version = "0.1.4";
            src = self.fetchFromGitHub {
              owner = "jneilliii";
              repo = "OctoPrint-WideScreen";
              rev = "${version}";
              sha256 = "sha256-y0yINi03e8YutsdHckSfjZtob8Je3Ff1aSbQxtLnbgw=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          filemanager = pyself.buildPythonPackage rec {
            pname = "FileManager";
            version = "0.1.6";
            src = self.fetchFromGitHub {
              owner = "Salandora";
              repo = "OctoPrint-FileManager";
              rev = "${version}";
              sha256 = "sha256-4znIdVjfU/PPoFXmHBAtp5vAxly0R/R24tGMVbiaiYk=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
          displaylayerprogress = pyself.buildPythonPackage rec {
            pname = "DisplayLayerProgress";
            version = "1.28.0";
            src = self.fetchFromGitHub {
              owner = "OllisGit";
              repo = "OctoPrint-DisplayLayerProgress";
              rev = "${version}";
              sha256 = "sha256-FoQGv7a3ktodyQKOwR69/9Up+wPoW5NDq+k5LfP9WYs=";
            };
            propagatedBuildInputs = [ pysuper.octoprint ];
            doCheck = false;
          };
        };
      };
    })
  ];
  systemd.services.octoprint.serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
  services.octoprint = {
    enable = true;
    openFirewall = true;
    group = "video";
    stateDir = "/home/octoprint";
    port = 80;
    extraConfig = {
      "secretKey" = "xRuJFDjhvhu7wALyV8XXyDIMBs9IzUUs";
    };
    plugins =
      plugins: with plugins; [
        #       printtimegenius
        #       stlviewer
        #       costestimation
        displaylayerprogress
        displayprogress
        dashboard # update to 1.19.11
        widescreen
        themeify
        filemanager
        prusaslicerthumbnails
        firmwareupdater
        slicerestimator
        resourcemonitor
        prusaresetmode
        cancelobject
        camerasettings
        bgcode
      ];
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    nftables.enable = true;
    #    firewall = {
    #      allowedTCPPorts = [ 80 ];
    #    };
    hostName = hostname;
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };

  services.timesyncd.enable = true;
  services.openssh.enable = true;

  users = {
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [
        "wheel"
        "gpio"
        "spi"
      ];
    };

    #    users.octoprint = {
    #     extraGroups = [ "video" ];
    #  };

    users.charles = {
      isNormalUser = true;
      uid = 1111;
      initialHashedPassword = "$6$v6PQnaaF2/FOFBtq$RGM/DUzJogCWKjdEJCxA0KFnLTBTxzIWDqgUUTAW2ZTAtxFrl4omDeXs3Nmu4KULBc1Lofn0Fh4IrnkDmuVbI/"; # mkpasswd -m SHA-512
      extraGroups = [
        "wheel"
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
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.groups.spi = { };

  # Create gpio group
  users.groups.gpio = { };
  # https://raspberrypi.stackexchange.com/questions/40105/access-gpio-pins-without-root-no-access-to-dev-mem-try-running-as-root
  services.udev.extraRules = ''
    KERNEL=="gpiomem", GROUP="gpio", MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", PROGRAM="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/chgrp -R gpio /sys/class/gpio && ${pkgs.coreutils}/bin/chmod -R g=u /sys/class/gpio'"
    SUBSYSTEM=="gpio", ACTION=="add", PROGRAM="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/chgrp -R gpio /sys%p && ${pkgs.coreutils}/bin/chmod -R g=u /sys%p'"
  '';

  # Change permissions gpio devices
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
  #   SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
  #   SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; ${pkgs.coreutils}/bin/chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
  #   SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; ${pkgs.coreutils}/bin/chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  # '';

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
