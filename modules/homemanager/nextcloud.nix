{pkgs, config, ...}:
{
    home.packages = with pkgs; [
        nextcloud-client
    ];
    systemd.user = {
        startServices = true;
        services.nextcloud-autosync = {
            Unit = {
                Description = "Auto sync Nextcloud";
                After = "network-online.target";
            };
            Service = {
                Type = "simple";
                EnvironmentFile="/run/user/1111/secrets/charles/nextcloud"; #FIXME dynamic user
                ExecStart="${pkgs.nextcloud-client}/bin/nextcloudcmd -h -s -u $USERNAME -p $PASSWORD --path / /home/charles/nextcloud https://cloud.ochman.info"; #FIXME exclude sync folders
                TimeoutStopSec = "180";
                KillMode = "process";
                KillSignal = "SIGINT";
            };
            Install.WantedBy = ["default.target"];
        };
        timers.nextcloud-autosync = {
            Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 5 minutes";
            Timer.OnBootSec = "5min";
            Timer.OnUnitActiveSec = "5min";
            Install.WantedBy = ["default.target" "timers.target"];
        };
    };
}
