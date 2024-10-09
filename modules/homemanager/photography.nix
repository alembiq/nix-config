{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    rapid-photo-downloader
    darktable
  ];
}
