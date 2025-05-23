# TO DO & FIX
- tune up SSH configs (probably draw inheritance structure)
- join sops secrets into ?one? file?
- wezterm focus follow mouse
- variable for `user home path`, `uid`, `gid`     ??? hm.config homedir ```${toString config.users.users.charles.uid}   ${toString config.users.groups.users.gid}```
- replace all 1111/charles references from modules/ with vars from user/host
- check variables/commands in systemd services for replacing charles/1111      {config.users.users.charles.uid}
- sops output file in variable ${config.sops.secrets.secret_api_key.path}
- sending mail (msmtp) notification
- incomming mail (mbsync/notmuch) notification
- mbsync Notice: SSLType is deprecated. Use TLSType instead.
- notmuch compact
- hyprland go suspend after first login when laptop closed
- nixpkgs-wayland.packages.${system}.wayprompt not working with sops-nix
- greetd does not contain BASH
- list updated packages also when doing nixos-rebuild boot
## MOVE
- move `/home/charles/.gnupg move` to `GNUPGHOME="$XDG_DATA_HOME"/gnupg` > programs.gpg.homedir = "${hm.config.xdg.dataHome}/gnupg";
- move mailbox `accounts.email.maildirBasePath` to `.local/shared/mail/` + zfs (disko)
- move ~/Calibre Library
- move ~/.viminfo ~/.mysql_history
- move ~/.composer ~/.docker
- move ~/log ~/.msmtp.queue/
- move ~/.waveterm ~/.mozilla ~/.vscode-oss`
- separate HOME-MANAGER but include in HOST
# VERDANDI
- SWAP for hibernate vs encrypted SWAP
# BADB
- fixed default wifi
- sops-nix & yubikey
- GUI vs TUI
# OCTOPI
- rpi image builder
- merge into new repository/configuration
# BROKKR
- remote build (vpsfree)
# EIR
- create
# FORGE
- gitlab-runner (docker & hugo)
- jellyfin (transcoding)
- sops-nix
- remote user (ernedar)
- systemd-boot (resolution, font)
# HOMEMANAGER
- mail
- secrets (sops-nix)
- GPG
- SSH


```
home.file."${hm.config.programs.gpg.homedir}/.keep".text = "";
```


# NORDIC theme
base00: "#2E3440"
base01: "#3B4252"
base02: "#434C5E"
base03: "#4C566A"
base04: "#D8DEE9"
base05: "#E5E9F0"
base06: "#ECEFF4"
base07: "#8FBCBB"
base08: "#88C0D0"
base09: "#81A1C1"
base0A: "#5E81AC"
base0B: "#BF616A"
base0C: "#D08770"
base0D: "#EBCB8B"
base0E: "#A3BE8C"
base0F: "#B48EAD"



# nmcli
```
     nmcli con show
     nmcli con modify HotelWifiName wifi.cloned-mac-address 70:48:f7:1a:2b:3c
     nmcli device disconnect wlp0s20f3
     nmcli device connect wlp0s20f3
```
