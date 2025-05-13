# https://github.com/Alexays/Waybar/wiki/Styling

{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0;
        font-size: 9pt;

        box-shadow: none;
        text-shadow: none;
        transition-duration: 0s;
        padding: 0pt;
        margin: 0pt;
        color: #${config.lib.stylix.colors.base0D};
    }
    window.eDP-1 * {
        font-size: 8pt;
        font-weight: bold;
    }
    window, window#waybar {
        background: transparent;
    }
    #workspaces button.active {
        color: #${config.lib.stylix.colors.base00};
        background: #${config.lib.stylix.colors.base00};
    }
    #workspaces button.urgent {
        color: #${config.lib.stylix.colors.base0B};
    }

    #custom-appmenu, #workspaces, #tray, #window, #clock,
    #audio, #connectivity, #gui, #hardware, #custom-quit {
        margin: 0pt 3pt 0pt 3pt;
        padding: 0pt 6pt 0pt 6pt;
        border-radius: 10pt;
        background: #${config.lib.stylix.colors.base01};
        color: #${config.lib.stylix.colors.base04};
    }
    #temperature, #cpu, #memory, #backlight, #battery, #custom-quit {
        margin: 0pt 3pt 0pt 3pt;
    }
    #hardware.div {
        margin: 0pt 3pt 0pt 3pt;
    }
    #battery.warning {
        color: #${config.lib.stylix.colors.base09};
    }
    #battery.critical {
        color: #${config.lib.stylix.colors.base08};
    }
    #battery.charging {
        color: #${config.lib.stylix.colors.base0A};
    }
  '';
  programs.waybar.settings = {
    mainBar = {
      layer = "bottom";
      position = "top";
      spacing = 0;
      margin = "none";
      reload_style_on_change = true;
      output = [ "*" ];
      modules-left = [
        "custom/appmenu"
        "sway/workspaces"
        "hyprland/workspaces"
        "tray"
        "sway/window"
        "hyprland/window"
      ]; # "custom/yubikey"
      "custom/appmenu" = {
        format = "󱄅 ";
        on-click = "${pkgs.wofi}/bin/wofi --show drun | xargs swaymsg exec --";
        tooltip = false;
      };
      "sway/workspaces" = {
        all-outputs = true;
      };
      "hyprland/workspaces" = {
        "format" = "{icon}";
        "on-click" = "activate";
        "on-scroll-up" = "hyprctl dispatch workspace e+1";
        "on-scroll-down" = "hyprctl dispatch workspace e-1";
        "all-outputs" = true;
        "ignore-workspaces" = [
          "scratch"
          "-"
        ];
      };
      "tray" = {
        spacing = 5;
        icon-size = 12;
      };
      modules-center = [ "clock" ];
      "clock" = {
        interval = 1;
        format = " {:%a %d.%m.%Y %I:%M:%S} ";
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
      };
      modules-right = [
        "group/audio"
        "group/connectivity"
        "group/gui"
        "group/hardware"
      ];
      "idle_inhibitor" = {
        format = "{icon}";
        format-alt = "{icon} idle {status}";
        format-alt-click = "click-right";
        format-icons = {
          activated = " 󰋜 ";
          deactivated = " 󰦑 ";
        };
      };
      "group/audio" = {
        orientation = "horizontal";
        modules = [ "pulseaudio" ]; # "wireplumber"
      };
      "wireplumber" = {
        format = "{icon} {volume}%";
        format-muted = "";
        on-click = "${pkgs.easyeffects}/bin/easyeffects";
        on-click-right = "${pkgs.pwvucontrol}/bin/pwvucontrol";
        tooltip = "{node_name}";
        format-icons = [
          " "
          " "
          "󰕾 "
          "󰕾 "
          "󰕾 "
          " "
          " "
          " "
        ];
      };
      "pulseaudio" = {
        format = "{icon}  {volume}%  {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "󰟅";
          phone = "";
          portable = "";
          car = "";
          default = [
            " "
            " "
            "󰕾 "
            "󰕾 "
            "󰕾 "
            " "
            " "
            " "
          ];
        };
        on-click-right = "${pkgs.easyeffects}/bin/easyeffects";
        on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
      };
      "group/connectivity" = {
        orientation = "horizontal";
        modules = [
          "network"
          "custom/vpn"
          "bluetooth"
        ];
      };
      "network" = {
        format-wifi = "   {essid} ({signalStrength}%)";
        format-ethernet = "   {ipaddr}/{cidr} ";
        tooltip-format = " 󰒍  {ifname} via {gwaddr}";
        format-linked = "   {ifname} (No IP)";
        format-disconnected = " ⚠ Disconnected";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        on-click-right = "/run/current-system/sw/bin/nmtui";
      };
      "custom/vpn" = {
        format = "   VPN";
        exec = "echo '{\"class\": \"connected\"}'";
        exec-if = "test -d /proc/sys/net/ipv4/conf/tun0";
        return-type = "json";
        interval = 5;
      };
      "bluetooth" = {
        format = "  {status} ";
        format-connected = "  {num_connections}";
        tooltip-format = ''
          {controller_alias}	{controller_address}

          {num_connections} connected'';
        tooltip-format-connected = ''
          {controller_alias}	{controller_address}

          {num_connections} connected

          {device_enumerate}'';
        tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias}	{device_address}	{device_battery_percentage}%";
        on-click = "${pkgs.overskride}/bin/overskride";
      };
      "group/gui" = {
        orientation = "horizontal";
        modules = [
          "custom/notification"
          "sway/language"
          "hyprland/language"
          "idle_inhibitor"
        ];
      };
      "sway/language" = {
        format = "{shortDescription}";
        tooltip = false;
        on-click = "${pkgs.sway}/bin/swaymsg input 1:1:AT_Translated_Set_2_keyboard xkb_switch_layout next";
      };
      "hyprland/language" = {
        format = "{shortDescription}";
        tooltip = false;
        on-click = ''${pkgs.hyprland}/bin/hyprctl --batch "switchxkblayout at-translated-set-2-keyboard next ; ergo-k860-keyboard next"'';
      };
      "custom/notification" = {
        "tooltip" = false;
        "format" = " {icon} ";
        "format-icons" = {
          "notification" = " <span foreground='red'><sup>⬤</sup></span>";
          "none" = " ";
          "dnd-notification" = " <span foreground='red'><sup>⬤</sup></span>";
          "dnd-none" = " ";
          "inhibited-notification" = " <span foreground='red'><sup>⬤</sup></span>";
          "inhibited-none" = " ";
          "dnd-inhibited-notification" = " <span foreground='red'><sup>⬤</sup></span>";
          "dnd-inhibited-none" = " ";
        };
        "return-type" = "json";
        "exec" = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
        "on-click" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
        "on-click-right" = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
        "escape" = true;
      };

      "group/hardware" = {
        orientation = "horizontal";
        modules = [
          "cpu"
          "temperature"
          "memory"
          "backlight"
          "power-profiles-daemon"
          "battery"
          "custom/quit"
        ];
      };

      "power-profiles-daemon" = {
        format = "{icon}   {profile}";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };

      "cpu" = {
        format = " {usage}%";
        interval = 5;
        "on-click" = "${pkgs.resources}/bin/resources";
      };

      "temperature" = {
        hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 90;
        warning-threshold = 80;
        format = "🌡 {temperatureC}°C";
        format-warning = "🔥 {temperatureC}°C";
        format-critical = "💀 {temperatureC}°C";
      };

      "memory" = {
        format = "  {}%";
        tooltip-format = "RAM: {used:0.1f}GiB/{total:0.1f}GiB ({percentage}%) SWAP: {swapUsed:0.1f}GiB/{swapTotal:0.1f}GiB ({swapPercentage}%)";
        interval = 5;
        "on-click" = "${pkgs.resources}/bin/resources";
      };
      "backlight" = {
        format = "{icon}";
        format-alt = "{icon} {percent}%";
        format-alt-click = "click-right";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
          " "
          " "
          " "
          "🪩 "
        ];
        on-scroll-up = "${pkgs.light}/bin/light -A 5";
        on-scroll-down = "${pkgs.light}/bin/light -U 5";
      };
      "battery" = {
        format = "<span font='Font Awesome 6 Free 11'>{icon}</span>{capacity}% - {time}";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
        ];
        format-time = "{H}h{M}m";
        format-charging = "<span font='Font Awesome 6 Free'></span>  <span font='Font Awesome 6 Free 11'>{icon}</span>  {capacity}% - {time}";
        format-full = "<span font='Font Awesome 6 Free'></span>  <span font='Font Awesome 6 Free 11'>{icon}</span>  Charged";
        interval = 30;
        states = {
          warning = 25;
          critical = 10;
        };
        tooltip = false;
      };
      "custom/quit" = {
        format = " ";
        tooltip = false;
        on-click = "${pkgs.wlogout}/bin/wlogout";
      };
    };
  };

  programs.waybar.enable = true;

}
