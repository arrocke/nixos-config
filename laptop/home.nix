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

  # The version this config is compatible with.
  # You shouldn't need to change this when upgrading.
  home.stateVersion = "24.11";
}

