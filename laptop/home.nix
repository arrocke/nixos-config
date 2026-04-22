{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared/sway.nix
  ];
  
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    zoom-us
    chromium
    tmux
    xfce.thunar
    pgmanage

    neovim
    gcc # needed for treesitter
    ripgrep # needed for telescope

    # for screenshots
    grim
    slurp
    sway-contrib.grimshot
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Adrian Rocke";
      user.email = "me@adrianrocke.com";
      init.defaultBranch = "main";
    };
  };

  wayland.windowManager.sway = {
    config = {
        output = {
            "DP-7" = {
                mode = "1920x1080";
                position = "1920 0";
            };
            "DP-9" = {
                mode = "1920x1080";
                position = "0 0";
            };
            "eDP-1" = {
                mode = "2880x1920";
                position = "2880 1080";
            };
        };

        bindswitches = {
          "lid:on" = {
            reload = true;
            locked = true;
            action = "output eDP-1 disable";
          };
          "lid:off" = {
            reload = true;
            locked = true;
            action = "output eDP-1 enable";
          };
        };
    };
  };

  # The version this config is compatible with.
  # You shouldn't need to change this when upgrading.
  home.stateVersion = "24.11";
}

