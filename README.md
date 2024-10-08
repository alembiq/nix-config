# RANDOM notes
- get `UID` to a variable to adjust paths...
- move mailbox `accounts.email.maildirBasePath` to `.local/shared/mail/` + zfs (disko)
- move `/home/charles/.gnupg move` to `GNUPGHOME="$XDG_DATA_HOME"/gnupg` > programs.gpg.homedir = "${hm.config.xdg.dataHome}/gnupg";
- `hm.accounts.email.accounts` configuration to `.config/isync/mbsyncrc`
- https://github.com/nix-community/nixpkgs-wayland -> inputs.nixpkgs-wayland.packages.${system}.wayprompt  # from nixpkgs-wayland exclusively - pinentry UI
- sending mail (msmtp) notification
- incomming mail (mbsync) notification
- cosmic ???
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
