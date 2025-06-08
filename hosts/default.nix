{
  config,
  lib,
  pkgs,
  nixpkgs-wayland,
  system,
  ...
}:

{

  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
  };

  environment.systemPackages = with pkgs; [
    sops
    gnupg
    wget
    tailscale
    sanoid
    pv
    mbuffer
    lzop
    zstd
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../secrets/wifi.yaml;
    secrets = {
      "wifi" = {
        # owner = "user";
        # path = "/etc/file";
      };
    };
  }; # END of SOPS

  programs = {
    ssh.startAgent = false;
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = lib.mkForce pkgs.pinentry-all; # nixpkgs-wayland.packages.${system}.wayprompt ;# pkgs.pinentry-qt; # pkgs.pinentry-curses;
      };
    };
    bash = {
      completion.enable = true;
      interactiveShellInit = ''
        source /etc/lsb-release
        printf '%.0s*' $(seq $COLUMNS)
        ${pkgs.figurine}/bin/figurine -f "DOS Rebel.flf" $(hostname)
        echo "Distro version: $DISTRIB_DESCRIPTION  Kernel version: $(uname -srm)" # | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
        printf '%.0s*' $(seq $COLUMNS)
        ssh-add -L # | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
        uptime # | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
        free -h
        zfs list
        printf '%.0s*' $(seq $COLUMNS)
      '';
      loginShellInit = "echo $USER login...";
      logout = ''
	history -a 
        printf '\e]0;\a'
	'';
      promptInit = ''
        [[ $PS1 && -f /run/current-system/sw/share/bash-completion/completions/git-prompt.sh ]] && . /run/current-system/sw/share/bash-completion/completions/git-prompt.sh
        if [ "$TERM" != "dumb" ] ; then
            red="\[\e[31m\]"
            green="\[\e[32m\]"
            brown="\[\e[33m\]"
            blue="\[\e[34m\]"
            uncolor="\[\e[m\]"
            if [[ $EUID == 0 ]] ; then #root
                PS1="$blue\D{%d/%m/%Y} \t$uncolor $green\h$uncolor \w$brown\$(__git_ps1)$uncolor $red# $uncolor"
            else
                PS1="$blue\D{%d/%m/%Y} \t$uncolor $green\u@\h$uncolor \w$brown\$(__git_ps1)$uncolor $blue\$ $uncolor"
            fi
            if test "$TERM" = "xterm"; then
                PS1="\[\033]2;\h:\u:\w\007\]$PS1"
            fi
        fi
      '';
      shellAliases = {
        "ls" = "ls --color=auto";
        "ll" = "ls -alF";
        "grep" = "grep --color=auto";
        "fgrep" = "fgrep --color=auto";
        "egrep" = "egrep --color=auto";
        "diff" = "diff --color=always";
        "ip" = "ip -c";
        "watch" = "watch -c";

        "dd" = "dd status=progress";
        "df" = "df -h";
        "du" = "du -h";
        "free" = "free -h";
        "ping" = "ping -D";
        "rsync" = "rsync -aP";
        "sudo-git" = "sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK git ";
        "lsblk" = "lsblk -o name,uuid,size,type,fstype,label,mountpoints";
        "wget" = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";

        "disableIPv6" = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1";
        "myip" = "dig +short myip.opendns.com @resolver1.opendns.com";

        "gitroot" = ''cd "$(git rev-parse --show-toplevel)"'';
        "yubikey-reload" = ''${pkgs.gnupg}/bin/gpg-connect-agent "scd serialno" "learn --force" /bye'';
        "gpg-agent-wipe" =
          ''ssh_keys=$(${pkgs.gnupg}/bin/gpg-connect-agent 'keyinfo --ssh-list' /bye | awk '{print $3}') && for key in $ssh_keys; do ${pkgs.gnupg}/bin/gpg-connect-agent "delete_key --force $key" /bye; done'';
        "gpg-agent-restart" = "${pkgs.gnupg}/bin/gpg-connect-agent killagent /bye";

        "docker-cleanup" =
          "echo 'cleaning sys images'; docker system prune -a -f; echo 'cleaning volumes'; docker volume prune -f";
        "docker-cleanup-volumes" = "docker volume prune -f";
        "docker-cleanup-images" = "docker system prune -a -f";
        # "docker-killall" = "for i in $(docker ps|cut -d\  -f1|grep -v CON); do docker kill ${i} ; done";
        "docker-update-images" =
          "docker image ls --format='{{.Repository}}:{{.Tag}}' | xargs -I {} docker pull {}";

      };
    };
  }; # END of programs

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # https://nixos.wiki/wiki/Fonts
  fonts = {
    packages = with pkgs; [
      fira-code
      nerd-fonts.fira-code
      noto-fonts-emoji
    ];
  };

  system.activationScripts = {
    # FIXME folder .gnupg creation
    gnupg = {
      text = ''
        mkdir -p /root/.gnupg
        chown root /root/.gnupg
      '';
    };
  };

  # https://github.com/vinnymeller/nixos-config/blob/master/programs/gpg/default.nix
  environment.shellInit = ''
    gpg-connect-agent updatestartuptty /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  services = {
    boulette = {
      enable = true; # Will enable and install `boulette` to your path.
      enableZsh = true; # Optional: Will add guards for `shutdown` and `reboot` commands to your `zsh` interactive shell sessions.
      enableBash = true; # Optional: Will add guards for `shutdown` and `reboot` commands to your `bash` interactive shell sessions.
      enableFish = true; # Optional: Will add guards for `shutdown` and `reboot` commands to your `fish` interactive shell sessions.
      enableSudoWrapper = true; # Optional
      commands = [
        "shutdown"
        "reboot"
      ]; # Optional
      challengeType = "hostname"; # Optional: Defaults to hostname. One of "ask" "hostname", or "numbers".
      sshOnly = true; # Boolean, default is`true`. Optional: Boulette confirmation prompts will be triggerd inside ssh session only. Only effects the enable{zsh,bash,fish} options.
    };

    fwupd.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    tailscale = {
      enable = true;
    };
    xserver.displayManager.sessionCommands = ''
      # https://github.com/NixOS/nixpkgs/commit/5391882ebd781149e213e8817fba6ac3c503740c
      ${pkgs.gnupg}/bin/gpg-connect-agent /bye
      export GPG_TTY=$(tty)
    '';
  }; # END of services

  networking = {
    firewall = {
      allowPing = true;
      trustedInterfaces = [ "tailscale0 " ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 ];
    };
    nftables.enable = true;
  };

  security.polkit.enable = true;

  nix = {
    extraOptions = ''
      warn-dirty = false
    '';
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
      ];
      auto-optimise-store = true;
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 40d";
    };
  };

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
          /run/current-system "$systemConfig"
    '';
  };

  system.stateVersion = "23.11";
}
