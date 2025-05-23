# some inspiration https://github.com/prasanthrangan/hyprdots/tree/main

{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      #   slurp grim
      hyprshot
      xdg-desktop-portal-hyprland
      wlogout
      hypridle
      hyprlock
      swaylock-effects
      wayland-protocols
      wayland-utils
      wofi
      wl-clip-persist
      wlroots
      waybar
      playerctl
      swaynotificationcenter
      notify-desktop
      imv
      libva # TODO evaluate
      dconf # TODO evaluate dconf2nix

    ];
  };
  services.wpaperd = lib.mkForce {
    enable = true;
    settings = {
      any = {
        path = "/home/charles/pictures/wallpapers";
        duration = "30s";
        mode = "center";
        sorting = "random";
      };
      eDP-1 = {
        path = "/home/charles/pictures/wallpapers/52204128092_76bb16feb4_k.jpg";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
  package = null;
  portalPackage = null;  # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    systemd.enable = true;
    systemd.variables = [ "--all" ];
    settings = {
      env = [
        "GTK_THEME,Nord"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "MOZ_ENABLE_WAYLAND,1"
        "GDK_SCALE,1"
      ];
      exec-once = [
        "systemctl --user start sops-nix"
        "${pkgs.udiskie}/bin/udiskie --no-automount --smart-tray &"
        "${pkgs.swaynotificationcenter}/bin/swaync"
        "${pkgs.wpaperd}/bin/wpaperd"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.dbus}/bin/dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all"
        "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard both"
        "${pkgs.waybar}/bin/waybar #systemctl --user restart waybar"
        "${pkgs.libsForQt5.polkit-kde-agent}/bin/polkit-kde-authentication-agent-1"
        "hyprctl setcursor Nordzy-cursors 32"
      ];
      monitor = [
        "eDP-1,1920x1080,320x1440,1"
        "desc:Lenovo Group Limited LEN T32h-20 VNA5ZT78,2560x1440,0x0,1"
      ];

      "$mod" = "SUPER";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-source-mute @DEFAULT_SOURCE@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        "SUPER, L, exec, ${pkgs.grim}/bin/grim ~/.local/screenlock.png && loginctl lock-session"
      ];
      bindel = [
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -q s +10%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -q s 10%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      bind =
        [
          ",switch:off:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,1920x1080,320x1440,1'"
          ",switch:on:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,disabled'"

          "$mod, RETURN, exec, wezterm" # terminal
          "$mod SHIFT, Q, killactive,"
          "CTRLALT, DELETE, exec, wlogout"
          ", XF86Lock, exec, wlogout"
          "$mod, F, fullscreen,"
          "$mod SHIFT, SPACE, togglefloating"
          "$mod, D, exec, pkill wofi || wofi --show drun"
          ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region -o $HOME/downloads"
          "ALT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m window -o $HOME/downloads"
          "$mod, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output -o $HOME/downloads"

          "ALT, SHIFT, exec, hyprctl --batch 'switchxkblayout at-translated-set-2-keyboard next ; ergo-k860-keyboard next'"

          # Move focus with mainMod + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          # Move window
          "$mod SHIFT, left, movewindow,l"
          "$mod SHIFT, right, movewindow,r"
          "$mod SHIFT, up, movewindow,u"
          "$mod SHIFT, down, movewindow,d"
          "$mod, Y, togglesplit"
          # Resize window
          "$mod CTRL,right,resizeactive,20 0"
          "$mod CTRL,left,resizeactive,-20 0"
          "$mod CTRL,up,resizeactive,0 -20"
          "$mod CTRL,down,resizeactive,0 20"
          # Example special workspace (scratchpad)
          "$mod, U, togglespecialworkspace, magic"
          "$mod SHIFT, U, movetoworkspace, special:magic"
          # Scroll through existing workspaces
          "CTRL ALT, left, workspace, e-1"
          "CTRL ALT, right, workspace, e+1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            ) 10
          )
        );
      "debug" = {
        "disable_logs" = false;
      };
      "general" = {
        "layout" = "dwindle";
        "allow_tearing" = false;
        "border_size" = 2;
        #FIXME 20250101
        "col.active_border" = "0xff" + config.lib.stylix.colors.base06;
        "col.inactive_border" = "0x33" + config.lib.stylix.colors.base03;
        "resize_on_border" = true;
        "gaps_in" = 2;
        "gaps_out" = 4;
      };
      "decoration" = {
        "rounding" = 10;
        "blur" = {
          "enabled" = true;
          "size" = 3;
          "passes" = 1;
        };
      };
      "animations" = {
        "enabled" = "yes";
        "bezier" = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        "animation" = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };
      "input" = {
        "kb_layout" = "us, cz";
        "kb_variant" = ", qwerty";
        "kb_options" = "grp:alt_shift_toggle";
        "numlock_by_default" = "true";
        "follow_mouse" = "1";
      };
      "misc" = {
        "disable_hyprland_logo" = "true";
        "disable_splash_rendering" = "true";
        "force_default_wallpaper" = "0";
        "vfr" = true;
      };
      "xwayland" = {
        "force_zero_scaling" = true;
      };
      "dwindle" = {
        # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
        "pseudotile" = "yes";
        "preserve_split" = "yes";
      };
    };
    extraConfig = ''
      # # will switch to a submap called resize
      # bind = $mainMod,R,submap,resize
      # # will start a submap called "resize"
      #     binde = ,up,resizeactive,0 -10
      #     binde = ,down,resizeactive,0 10
      #     binde = ,right, resizeactive, 100 0
      #     binde = ,left, resizeactive, -100 0
      #     # use reset to go back to the global submap
      #     bind=,escape,submap,reset
      #     # will reset the submap, meaning end the current one and return to the global one
      # submap=reset
      # # keybinds further down will be global again...

      #get window details with `hyprctl clients`
      # windowrulev2 = float, title:^(File Operation Progress)(.*)$
      windowrulev2 = opacity 1 0.85,class:^(firefox)$
      windowrule   = opacity 0.90 0.75, title:(.*)(VSCodium)$
      windowrulev2 = opacity 0.90 0.75,class:^(wofi)$

      windowrulev2 = workspace 9 silent, class:^(Element)$
      windowrulev2 = opacity 0.90 0.85,class:^(Element)$

      windowrulev2 = workspace 9 silent, class:^(BeeperTexts)$
      windowrulev2 = opacity 0.90 0.85,class:^(BeeperTexts)$

      windowrulev2 = workspace 8 silent, class:^(Morgen)$
      windowrulev2 = opacity 0.90 0.75,class:^(Morgen)$

      windowrulev2 = workspace 10 silent, class:^(obsidian)$
      windowrulev2 = opacity 0.90 0.85,class:^(obsidian)$
      windowrulev2 = opacity 0.90 0.75,class:^(blueman-manager)$
      windowrulev2 = opacity 0.90 0.75,class:^(org.pulseaudio.pwvucontrol)$
      windowrulev2 = opacity 0.90 0.75,class:^(org.kde.polkit-kde-authentication-agent-1)$
      windowrulev2 = opacity 0.90 0.75,class:^(org.freedesktop.impl.portal.desktop.hyprland)$
      windowrulev2 = opacity 0.90 0.75,class:^(org.wezfurlong.wezterm)$
      windowrulev2 = move onscreen cursor, class:^(org.wezfurlong.wezterm)$
    '';
  };
}
