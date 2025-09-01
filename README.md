 /home/charles/.pki

  Disclaimer: XDG is supported, but directory may be created again by some
  programs.

  XDG is supported out-of-the-box, so we can simply move directory to
  "$XDG_DATA_HOME"/pki.

  Note: some apps (chromium, for example) hardcode path to "$HOME"/.pki, so
  directory may appear again, see
  https://bugzilla.mozilla.org/show_bug.cgi?id=818686#c11
  https://bugzilla.mozilla.org/show_bug.cgi?id=818686#c11.



[nix]: /home/charles/.nix-defexpr

  New nix command line interface supports XDG Base Directory but Old Commands
  will still create these directories.

  To use the XDG spec with the old command line, add to  /etc/nix/nix.conf :

   use-xdg-base-directories = true

  You also have to manually move the the file to XDG_STATE_HOME:

   mv "$HOME/.nix-defexpr" "$XDG_STATE_HOME/nix/defexpr"

  See the Manual: https://nixos.org/manual/nix/stable/command-ref/conf-
  file#conf-
  use-xdg-base-directories

[nix]: /home/charles/.nix-profile

  New nix command line interface supports XDG Base Directory but Old Commands
  will still create these directories.

  To use the XDG spec with the old command line, add to  /etc/nix/nix.conf :

   use-xdg-base-directories = true

  You also have to manually move the the file to XDG_STATE_HOME:

   mv "$HOME/.nix-profile" "$XDG_STATE_HOME/nix/profile"

  See the Manual: https://nixos.org/manual/nix/stable/command-ref/conf-
  file#conf-
  use-xdg-base-directories

[gnupg]: /home/charles/.gnupg

  Export the following environment variables:

    export GNUPGHOME="$XDG_DATA_HOME"/gnupg

  Note: from the archwiki:

  │ If you use non-default GnuPG Home directory, you will need to edit all
  │ socket files to use the values of gpgconf --list-dirs.
  │ If you set your SSH_AUTH_SOCK manually, keep in mind that your socket
  │ location may be different if you are using a custom GNUPGHOME




# TO DO & FIX
- tune up SSH configs (probably draw inheritance structure)

- join sops secrets - one file per machine? && one file per user?
- sops output file in variable ${config.sops.secrets.secret_api_key.path}

- variable for `user home path`, `uid`, `gid`     ??? hm.config homedir ```${toString config.users.users.charles.uid}   ${toString config.users.groups.users.gid}```
- check variables/commands in systemd services for replacing charles/1111      {config.users.users.charles.uid}
- replace all 1111/charles references from modules/ with vars from user/host

- sending mail (msmtp) notification
- incomming mail (mbsync/notmuch) notification
```
    kvě 29 11:25:40 verdandi mbsync[1326288]: Channels: 5    Boxes: 64    Far: +0 *0 #0 -0    Near: +0 *0 #0 -0
    kvě 29 11:25:40 verdandi notmuch[1326606]: No new mail.
```
- greetd does not contain BASH
- list updated packages also when doing nixos-rebuild boot
## MOVE
- move `/home/charles/.gnupg move` to `GNUPGHOME="$XDG_DATA_HOME"/gnupg` > programs.gpg.homedir = "${hm.config.xdg.dataHome}/gnupg";
- move mailbox `accounts.email.maildirBasePath` to `.local/shared/mail/` + zfs (disko)
- move ~/.viminfo ~/.mysql_history
- move calibre library  ~/.config/calibre/global.py.json:  "library_path": "/home/charles/Calibre Library",
- move ~/.composer ~/.docker
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
