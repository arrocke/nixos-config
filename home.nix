{ config, pgks, ... }:

{
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  programs.home-manager.enable = true;

  # The version this config is compatible with.
  # You shouldn't need to change this when upgrading.
  home.stateVersion = "24.11";
}
