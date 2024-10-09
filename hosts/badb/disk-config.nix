{
  disko.devices = {
    disk = {
      x = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            encryptedSwap = {
              size = "4G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100; # prefer to encrypt as long as we have space for it
              };
            };
            plainSwap = {
              size = "4G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true; # resume from hiberation from this device
              };
            };
            zfs = {
              size = "20G";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          encryption = "aes-256-gcm";
          # keyformat = "passphrase";
          keylocation = "file:///tmp/secret.key";
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
            mountpoint = "/homes";
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
        };
      };
    };
  }; # END of disko.devices
}
