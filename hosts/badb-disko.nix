{
    disko.devices = {
        disk = {
            nvme = {
                device = "/dev/sda";
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
                            size = "100G";
                            content = {
                                type = "zfs";
                                pool = "zpool";
                            };
                        };
                        plainSwap = {
                            size = "4G";
                            content = {
                                type = "swap";
                                resumeDevice = true; # resume from hiberation from this device
                            };
                        };
                        encryptedSwap = {
                            size = "4G";
                            content = {
                                type = "swap";
                                randomEncryption = true;
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
                   "home/charles/torrent" = {
                       type = "zfs_fs";
                       mountpoint = "/home/charles/Downloads/torrent";
                   };
                    "home/charles/nextcloud" = {
                        type = "zfs_fs";
                        mountpoint = "/home/charles/nextcloud";
                    };
                };
            };
        };
    }; #END of disko.devices
}
