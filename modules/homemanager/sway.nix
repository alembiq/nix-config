{
  config,
  lib,
  pkgs,
  ...
}:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-enviroment";
    executable = true;
    text = ''
      dbus-update-activation-enviroment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
    -t warning \
    -m 'What do you want to do?' \
    -b 'Poweroff' 'systemctl poweroff' \
    -b 'Reboot' 'systemctl reboot'
  '';
  modifier = "Mod4";
  term = "wezterm";
  menu = "wofi --show drun | xargs swaymsg exec --";
in
{
  # home.sessionVariables = {
  #     XDG_CURRENT_DESKTOP = "sway";
  # };
  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      client.focused           #${config.lib.stylix.colors.base05}  #${config.lib.stylix.colors.base0D}  #${config.lib.stylix.colors.base00}  #${config.lib.stylix.colors.base0D}  #${config.lib.stylix.colors.base0D}
      client.focused_inactive  #${config.lib.stylix.colors.base01}  #${config.lib.stylix.colors.base01}  #${config.lib.stylix.colors.base05}  #${config.lib.stylix.colors.base03}  #${config.lib.stylix.colors.base01}
      client.unfocused         #${config.lib.stylix.colors.base01}  #${config.lib.stylix.colors.base00}  #${config.lib.stylix.colors.base05}  #${config.lib.stylix.colors.base01}  #${config.lib.stylix.colors.base01}
      client.urgent            #${config.lib.stylix.colors.base08}  #${config.lib.stylix.colors.base08}  #${config.lib.stylix.colors.base00}  #${config.lib.stylix.colors.base08}  #${config.lib.stylix.colors.base08}
      client.placeholder       #${config.lib.stylix.colors.base00}  #${config.lib.stylix.colors.base00}  #${config.lib.stylix.colors.base05}  #${config.lib.stylix.colors.base00}  #${config.lib.stylix.colors.base00}
      client.background        #${config.lib.stylix.colors.base07}
      # SCRATCHPAD
      exec_always --no-startup-id xfce4-terminal --title=scratchpadTerminal
      exec_always --no-startup-id xfce4-terminal --title=scratchpadMutt
      for_window [title="scratchpadTerminal"] move scratchpad
      for_window [title="scratchpadTerminal"] floating enable, border pixel 5, resize set 1250 730
      bindsym Mod4+u [title="scratchpadTerminal"] scratchpad show; [title="scratchpadTerminal"] move position center
      for_window [title="scratchpadMutt"] move scratchpad
      for_window [title="scratchpadMutt"] floating enable, border pixel 5, resize set 1250 730
      bindsym Mod4+m [title="scratchpadMutt"] scratchpad show; [title="scratchpadMutt"] move position center
      # CLAMSHELL
      bindswitch --reload --locked lid:on output eDP-1 disable
      bindswitch --reload --locked lid:off output eDP-1 enable
      exec_always ${
        pkgs.writeShellScript "sway-lid-switch-toggle-output" # bash
          ''
            if grep -q open /proc/acpi/button/lid/LID/state; then
                swaymsg output eDP-1 enable
            else
                swaymsg output eDP-1 disable
            fi
          ''
      }
    '';
    config = {
      fonts = {
        names = [ "Roboto" ];
        style = "Regular Bold";
        size = 12.0;
      };

      gaps = {
        smartBorders = "on";
        smartGaps = true;
      };
      window.border = 1;
      bars = [ ];
      input = {
        "*" = {
          xkb_layout = "us,cz";
          xkb_variant = ",qwerty";
          xkb_options = "grp:alt_shift_toggle";
          xkb_numlock = "enable";
        };
        "Raydium_Corporation_Raydium_Touch_System" = {
          "map_to_output" = "eDP-1";
        };
      };
      startup = [
        { command = "${pkgs.waybar}/bin/waybar"; }
        { command = "${pkgs.swaynotificationcenter}/bin/swaync"; }
        { command = "${pkgs.firefox}/bin/firefox"; }
        {
          command = "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1";
        }
        {
          command = "sleep 5 && ${pkgs.element-desktop}/bin/element-desktop";
        }
        #FIXME inherit ALLOW_UNFREE { command = "sleep 5 && ${pkgs.beeper}/bin/beeper"; }
        #FIXME inherit ALLOW_UNFREE { command = "sleep 8 && ${pkgs.obsidian}/bin/obsidian --disable-gpu"; } # https://github.com/NixOS/nixpkgs/issues/270699
        #FIXME inherit ALLOW_UNFREE { command = "sleep 8 && ${pkgs.morgen}/bin/morgen"; }
        { command = "sway-audio-idle-inhibit"; }

      ];
      assigns = {
        # wlprop
        "2" = [ { app_id = "firefox"; } ];
        "7" = [ { class = "Morgen"; } ];
        "8" = [
          { app_id = "Element"; }
          { app_id = "Beeper"; }
          { class = "teams-for-linux"; }
        ];
        "9" = [ { app_id = "obsidian"; } ];
      };
      floating = {
        titlebar = true;
        border = 1;
      };

      menu = menu;
      modifier = modifier;
      keybindings = {
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway?' -b 'Yes, exit sway' 'swaymsg exit' -b 'Poweroff' 'systemctl poweroff' -b 'Reboot' 'systemctl reboot'";
        "${modifier}+l" = "exec swaylock-effects'";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+q" = "kill";
        "Mod1+Control+Delete" = "${pkgs.wlogout}/bin/wlogout";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Return" = "exec kitty";
        "Print" = "exec slurp | grim -g - $HOME/downloads/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%-";
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86MonBrightnessDown" = "exec light -U 10";
        # Moving around
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";
        "Mod1+Ctrl+Right" = "workspace next";
        "Mod1+Ctrl+Left" = "workspace prev";
        # Workspacesbindsym $mod
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        # Layout stuff
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+f" = "fullscreen";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+a" = "focus parent";
        # Scratchpad
        # "${modifier}+u" = "[title='scratchpadTerminal'] scratchpad show; [title='scratchpadTerminal'] move position center";
        # "${modifier}+m" = "[title='scratchpadMutt'] scratchpad show; [title='scratchpadMutt'] move position center";
        # Resizing containers
        "${modifier}+r" = "mode 'resize'";
      };
      modes = {
        resize = {
          "${modifier}+Left" = "resize shrink width 10px";
          "${modifier}+Down" = "resize grow height 10px";
          "${modifier}+Up" = "resize shrink height 10px";
          "${modifier}+Right" = "resize grow width 10px";
          "Return" = "mode 'default'";
          "Escape" = "mode 'default'";
        };
      };
      terminal = term;
      window.titlebar = false;
      workspaceAutoBackAndForth = true;
    };
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      ignore-empty-password = true;
      indicator = true;
      indicator-idle-visible = true;
      indicator-caps-lock = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      line-uses-inside = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;
      grace = 2;
    };
  };

}
