{pkgs, config, ...}:
{ #https://wiki.nixos.org/wiki/Docker
    virtualisation.docker= {
        enable = true;
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };
}
