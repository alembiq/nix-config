# RANDOM notes

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

${pkgs.swayidle} -w timeout 60 "hyprlock" before-sleep "hyprlock" & # lock screen after 10 min of idle
${pkgs.swayidle} -w timeout 1200 "systemctl hibernate" &             # hibernate after 20 mins of idle

https://raw.githubusercontent.com/TheMaxMur/NixOS-Configuration/master/home/modules/hypridle/default.nix
https://raw.githubusercontent.com/TheMaxMur/NixOS-Configuration/master/home/modules/hyprlock/default.nix
