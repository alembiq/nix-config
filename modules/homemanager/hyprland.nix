# some inspiration https://github.com/prasanthrangan/hyprdots/tree/main

{ pkgs, lib, config, ... }:
{
        home = {
            packages = with pkgs; [
                slurp grim
                # xdg-desktop-portal-wlr
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
    #             libsForQt5.polkit-kde-agent
                udiskie
                swaynotificationcenter
            ];
        };
#TODO wpaperd vs stylix.image mkforce
        programs.wpaperd = {
            enable = true;
#             #     settings = {
#             #         any = {
#             #             path = "/home/charles/nextcloud/Pictures/wallpapers";
#             #             duration = "30s";
#             #             mode = "fit";
#             #             sorting = "random";
#             #         };
#             #         eDP-1 = {
#             #             path = "/home/charles/nextcloud/Pictures/wallpapers/52204128092_76bb16feb4_k.jpg";
#             #         };
#             #     };
        };
        xdg.configFile."wpaperd/config.toml" = {
            text = ''
            [any]
            path = "/home/charles/nextcloud/Pictures/wallpapers"
            duration = "30s"
            mode = "center"
            sorting = "random"
            [eDP-1]
            path = "/home/charles/nextcloud/Pictures/wallpapers/52204128092_76bb16feb4_k.jpg"
            '';
        };

        wayland.windowManager.hyprland = {
            enable = true;
            package = pkgs.hyprland;
            xwayland.enable = true;
            systemd.enable = true;
            systemd.variables = ["--all"];
            settings = {
                env = [
                    "GTK_THEME,Nord"
                    "XDG_CURRENT_DESKTOP,Hyprland"
                    "XDG_SESSION_TYPE,wayland"
                    "XDG_SESSION_DESKTOP,Hyprland"
                    "QT_QPA_PLATFORM,wayland;xcb"
                    "QT_QPA_PLATFORMTHEME,qt6ct"
                    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                    "QT_AUTO_SCREEN_SCALE_FACTOR,1"
                    "MOZ_ENABLE_WAYLAND,1"
                    "GDK_SCALE,1"
                ];
                exec-once = [
                    "${pkgs.udiskie}/bin/udiskie --no-automount --smart-tray &"
                    "${pkgs.swaynotificationcenter}/bin/swaync"
                    "${pkgs.wpaperd}/bin/wpaperd"
                    "${pkgs.dbus}/bin/dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"
                    "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard both"
    #FIXME clipboard
    #   exec-once = wl-paste --type text  --watch cliphist store -max-items 1000
    #   exec-once = wl-paste --type image --watch cliphist store -max-items 1000
                    "${pkgs.waybar}/bin/waybar #systemctl --user restart waybar"
                    "${pkgs.libsForQt5.polkit-kde-agent}/bin/polkit-kde-authentication-agent-1"
                    "${pkgs.wpaperd}/bin/wpaperd &"
                    "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all"
                    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    # FIXME suspend/resume does not requires password
                    # "${pkgs.swayidle}/bin/swayidle -w timeout 90 '${pkgs.swaylock-effects}/bin/swaylock -f' timeout 210 'suspend-unless-render' resume '${pkgs.hyprland}/bin/hyprctl dispatch dpms on' before-sleep '${pkgs.swaylock-effects}/bin/swaylock -f'"
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
                    " , XF86AudioMute, exec, $scrPath/volumecontrol.sh -o m" # toggle audio mute
                    " , XF86AudioMicMute, exec, $scrPath/volumecontrol.sh -i m" # toggle microphone mute
                ];
                bindel = [
                    " , XF86AudioLowerVolume, exec, $scrPath/volumecontrol.sh -o d" # decrease volume
                    " , XF86AudioRaiseVolume, exec, $scrPath/volumecontrol.sh -o i" # increase volume
                    " , XF86AudioLowerVolume, exec, $scrPath/volumecontrol.sh -o d" # decrease volume
                    " , XF86AudioRaiseVolume, exec, $scrPath/volumecontrol.sh -o i" # increase volume
                ];
                bind = [
                    ",switch:off:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,1920x1080,320x1440,1'"
                    ",switch:on:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,disabled'"

                    "$mod, RETURN, exec, wezterm" # warp-terminal
                    "$mod SHIFT, Q, killactive,"
                    #FIXME lock without suspend "$mod, L, exec, swaylock -f --screenshots --effect-pixelate 20 --fade-in 0.2 ; hyprctl dispatch dpms off"
                    "CTRLALT, DELETE, exec, wlogout"
                    "$mod, F, fullscreen,"
                    "$mod SHIFT, SPACE, togglefloating"

                    "$mod, D, exec, pkill wofi || wofi --show drun"
                    ",Print,exec,slurp | grim -g - $HOME/Downloads/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')"
                    "ALT, SHIFT, exec, hyprctl --batch 'switchxkblayout at-translated-set-2-keyboard next ; ergo-k860-keyboard next'"

                    ", XF86MonBrightnessUp, exec, brightnessctl -q s +10%"
                    ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-"
                    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK 5%-"
                    #TODO identify proper keynames for audio
                    # ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                    # ", XF86AudioPlay, exec, playerctl play-pause"
                    # ", XF86AudioPause, exec, playerctl pause"
                    # ", XF86AudioNext, exec, playerctl next"
                    # ", XF86AudioPrev, exec, playerctl previous"
                    # ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
                    # ", XF86Lock, exec, hyprlock"

                    # Move focus with mainMod + arrow keys
                    "$mod, left, movefocus, l"
                    "$mod, right, movefocus, r"
                    "$mod, up, movefocus, u"
                    "$mod, down, movefocus, d"
                    # Move window
                    "SUPERSHIFT, left, movewindow,l"
                    "SUPERSHIFT, right, movewindow,d"
                    "SUPERSHIFT, up, movewindow,u"
                    "SUPERSHIFT, down, movewindow,r"

                    # Example special workspace (scratchpad)
                    "$mod, U, togglespecialworkspace, magic"
                    "$mod SHIFT, U, movetoworkspace, special:magic"
                    # Scroll through existing workspaces
                    "CTRL ALT, left, workspace, e-1"
                    "CTRL ALT, right, workspace, e+1"
                ] ++ (
                    # workspaces
                    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
                    builtins.concatLists (builtins.genList (
                        x: let
                        ws = let
                            c = (x + 1) / 10;
                        in
                            builtins.toString (x + 1 - (c * 10));
                        in [
                        "$mod, ${ws}, workspace, ${toString (x + 1)}"
                        "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                        ]
                    )
                    10)
                );
                "general" = {
                    "layout" = "dwindle";
                    "allow_tearing" = false;
                    "border_size" = 2;
                    "col.active_border" = "0xff'' + config.lib.stylix.colors.base08 + ''";
                    "col.inactive_border" = "0x33'' + config.lib.stylix.colors.base00 + ''";
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
                    "drop_shadow" = false;
                    "shadow_range" = 4;
                    "shadow_render_power" = 3;
                    "col.shadow" = "rgba(1a1a1aee)";
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

                windowrulev2 = workspace 9 silent, class:^(Beeper)$
                windowrulev2 = opacity 0.90 0.85,class:^(Beeper)$

                windowrulev2 = workspace 8 silent, class:^(Morgen)$
                windowrulev2 = opacity 0.90 0.75,class:^(Morgen)$

                windowrulev2 = workspace 10 silent, class:^(obsidian)$
                windowrulev2 = opacity 0.90 0.85,class:^(obsidian)$
                windowrulev2 = opacity 0.90 0.75,class:^(blueman-manager)$
                windowrulev2 = opacity 0.90 0.75,class:^(org.pulseaudio.pavucontrol)$
                windowrulev2 = opacity 0.90 0.75,class:^(org.kde.polkit-kde-authentication-agent-1)$
                windowrulev2 = opacity 0.90 0.75,class:^(org.freedesktop.impl.portal.desktop.hyprland)$
                windowrulev2 = opacity 0.90 0.75,class:^(org.wezfurlong.wezterm)$
                windowrulev2 = move onscreen cursor, class:^(org.wezfurlong.wezterm)$
            '';
        };
}
