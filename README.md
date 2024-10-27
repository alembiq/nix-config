# RANDOM notes
- join sops secrets into ?one? file?
- variable for `user home path`, `uid`, `gid`     ??? hm.config homedir
- replace all 1111/charles references from modules/ with vars from user/host
- check variables/commands in systemd services for replacing charles/1111
- sending mail (msmtp) notification
- incomming mail (mbsync/notmuch) notification
- mbsync Notice: SSLType is deprecated. Use TLSType instead.
- notmuch compact
- cosmic ???
- hyprland go suspend after first login when laptop closed
- nixpkgs-wayland.packages.${system}.wayprompt not working with sops-nix
## MOVE
- move `/home/charles/.gnupg move` to `GNUPGHOME="$XDG_DATA_HOME"/gnupg` > programs.gpg.homedir = "${hm.config.xdg.dataHome}/gnupg";
- move mailbox `accounts.email.maildirBasePath` to `.local/shared/mail/` + zfs (disko)
- move ~/Calibre Library
- move ~/.viminfo ~/.mysql_history
- move ~/.composer ~/.docker
- move ~/log ~/.msmtp.queue/
- move ~/.mbsyncrc (`hm.accounts.email.accounts` configuration to `.config/isync/mbsyncrc`)
- move ~/.waveterm ~/.mozilla ~/.vscode-oss`
### VERDANDI
- SWAP for hibernate vs encrypted SWAP
### BADB
- fixed default wifi
### OCTOPI
- rpi image builder
- merge properly ;)
### BROKKR
- create
### EIR
- create



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
