{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
#FIXME 20250428    rapid-photo-downloader
    darktable
  ];
}
