{ config, pkgs, ... }:

{
  imports = [
    ../shared/sway.nix
  ];

  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    zoom-us
    neovim
    chromium
    docker-compose
    pgadmin4-desktopmode
    tmux
    tmuxinator
    xfce.thunar
    ripgrep
  ];

  wayland.windowManager.sway = {
    config.output = {
        "HDMI-A-3" = {
            mode = "1920x1080";
            position = "1920 0";
        };
        "DP-1" = {
            mode = "1920x1080";
            position = "0 0";
        };
    };
  };

  # The version this config is compatible with.
  # You shouldn't need to change this when upgrading.
  home.stateVersion = "24.11";
}
