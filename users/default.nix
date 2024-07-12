{ pkgs, lib, ...}:

{
    programs = { # home-manager.users.<name>.programs
        direnv = {
            enable = true;
            enableBashIntegration = true; # see note on other shells below
            nix-direnv.enable = true;
        };
        bash = {
            enable = true;
            profileExtra = "gpgconf --launch gpg-agent";
            historyFileSize = -1;
            historyIgnore = [ "ls"  "cd"  "exit" ];
            historyControl = [ "erasedups" ];
        };
        gpg = { # https://github.com/drduh/YubiKey-Guide/blob/b57c7f7901f6d748d35c84a96609a64aa2301e50/flake.nix
            settings = { # https://home-manager-options.extranix.com/?query=program.gpg
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
                # StrictHostKeyChecking ask
                # VerifyHostKeyDNS yes
                # Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
                # MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
                # KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
                # HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
            ''; #TODO clear up what can be used
            hashKnownHosts = true;
            serverAliveCountMax = 30;
            serverAliveInterval = 300;
        };
    }; #END of home-manager.users.<name>.programs

     services = { # home-manager.users.<name>.services
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
    }; #END of home-manager.users.<name>.services

 }
