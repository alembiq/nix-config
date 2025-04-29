{
  disko.devices = {
    disk = {
      nvme = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountOptions = [ "umask=0077" ];
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "800G";
              content = {
                type = "zfs";
                pool = "zpool";
              };
            };
            plainSwap = {
              # TODO LUKS encrypt partition for hibernation
              size = "20G";
              content = {
                type = "swap";
                resumeDevice = true;
                discardPolicy = "both";
              };
            };
            encryptedSwap = {
              size = "20G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100;
              };
            };
          };
        };
      };
    };
    zpool = {
      zpool = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          # keylocation = "file:///tmp/secret.key";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zpool@blank$' || zfs snapshot zpool@blank";
        datasets = {
          "nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "nixos/etc" = {
            type = "zfs_fs";
            mountpoint = "/etc";
          };
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home"; 
          };
          "home/charles" = {
            type = "zfs_fs";
            mountpoint = "/home/charles";
          };
          "home/charles/mail" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/Maildir";
          };
          "home/charles/cache" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/.cache";
          };
          "home/charles/torrent" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/downloads/torrent";
          };
          "home/charles/documents" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/documents";
          };
          "home/charles/pictures" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/pictures";
          };
          "home/charles/games" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/games";
          };
          "home/charles/audio" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/audio";
          };
          "home/charles/workspace" = {
            type = "zfs_fs";
            mountpoint = "/home/charles/workspace";
          };
        };
      };
    };
  }; # END of disko.devices
}
