{ config, lib, pkgs, ... }:
{
    nix = {
        settings.builders-use-substitutes = true;
        buildMachines = [{
            hostName = "charles@kubera";
            system = "x86_64-linux";
            protocol = "ssh"; #TODO test ssh-ng
            maxJobs = 16;
            supportedFeatures = [ "nixos-test" "benchmanrk" "big-parallel" "kvm"];
            mandatoryFeatures = [];
            speedFactor = 4; #times (16x7568) faster than verdandi (8x3999)
        } ];
        distributedBuilds = true;
        extraOptions = ''
            builders-use-substitutes = true
        '';
    };
}
