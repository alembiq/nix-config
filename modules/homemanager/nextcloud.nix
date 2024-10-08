{pkgs, config, ...}:
{
    home.packages = with pkgs; [
        nextcloud-client
    ];
    systemd.user = {
        startServices = true;
        # AUDIO
        services.nextcloud-audio-autosync = {
            Unit = {
                Description = "Auto sync Nextcloud Audio";
                After = "network-online.target";
            };
            Service = {
                Type = "simple";
                EnvironmentFile="/run/user/1111/secrets/charles/nextcloud"; #FIXME dynamic user
                ExecStart="${pkgs.nextcloud-client}/bin/nextcloudcmd -h -s -u $USERNAME -p $PASSWORD --path /Audio /home/charles/audio https://cloud.ochman.info";
                TimeoutStopSec = "180";
                KillMode = "process";
                KillSignal = "SIGINT";
            };
            Install.WantedBy = ["default.target"];
        };
        timers.nextcloud-audio-autosync = {
            Unit.Description = "Automatic sync audio with Nextcloud when booted up after 5 minutes then rerun every 5 minutes";
            Timer.OnBootSec = "5min";
            Timer.OnUnitActiveSec = "5min";
            Install.WantedBy = ["default.target" "timers.target"];
        };
        # DOCUMENTS
        services.nextcloud-documents-autosync = {
            Unit = {
                Description = "Auto sync Nextcloud Documents";
                After = "network-online.target";
            };
            Service = {
                Type = "simple";
                EnvironmentFile="/run/user/1111/secrets/charles/nextcloud"; #FIXME dynamic user
                ExecStart="${pkgs.nextcloud-client}/bin/nextcloudcmd -h -s -u $USERNAME -p $PASSWORD --path /Documents /home/charles/documents https://cloud.ochman.info";
                TimeoutStopSec = "180";
                KillMode = "process";
                KillSignal = "SIGINT";
            };
            Install.WantedBy = ["default.target"];
        };
        timers.nextcloud-documents-autosync = {
            Unit.Description = "Automatic sync documents with Nextcloud when booted up after 5 minutes then rerun every 5 minutes";
            Timer.OnBootSec = "5min";
            Timer.OnUnitActiveSec = "5min";
            Install.WantedBy = ["default.target" "timers.target"];
        };

        # GAMES
        services.nextcloud-games-autosync = {
            Unit = {
                Description = "Auto sync Nextcloud Games";
                After = "network-online.target";
            };
            Service = {
                Type = "simple";
                EnvironmentFile="/run/user/1111/secrets/charles/nextcloud"; #FIXME dynamic user
                ExecStart="${pkgs.nextcloud-client}/bin/nextcloudcmd -h -s -u $USERNAME -p $PASSWORD --path /Games /home/charles/games https://cloud.ochman.info";
                TimeoutStopSec = "180";
                KillMode = "process";
                KillSignal = "SIGINT";
            };
            Install.WantedBy = ["default.target"];
        };
        timers.nextcloud-games-autosync = {
            Unit.Description = "Automatic sync games with Nextcloud when booted up after 5 minutes then rerun every 5 minutes";
            Timer.OnBootSec = "5min";
            Timer.OnUnitActiveSec = "5min";
            Install.WantedBy = ["default.target" "timers.target"];
        };

        # PICTURES
        services.nextcloud-pictures-autosync = {
            Unit = {
                Description = "Auto sync Nextcloud pictures";
                After = "network-online.target";
            };
            Service = {
                Type = "simple";
                EnvironmentFile="/run/user/1111/secrets/charles/nextcloud"; #FIXME dynamic user
                ExecStart="${pkgs.nextcloud-client}/bin/nextcloudcmd -h -s -u $USERNAME -p $PASSWORD --path /InstantUpload /home/charles/pictures https://cloud.ochman.info";
                TimeoutStopSec = "180";
                KillMode = "process";
                KillSignal = "SIGINT";
            };
            Install.WantedBy = ["default.target"];
        };
        timers.nextcloud-pictures-autosync = {
            Unit.Description = "Automatic sync pictures with Nextcloud when booted up after 5 minutes then rerun every 5 minutes";
            Timer.OnBootSec = "5min";
            Timer.OnUnitActiveSec = "5min";
            Install.WantedBy = ["default.target" "timers.target"];
        };

    };
}
