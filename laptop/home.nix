{ config, pkgs, ... }:

{
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  programs.home-manager.enable = true;

  wayland.windowManager.sway = {
    enable = true;

    config = {
      fonts = {
        names = [ "InconsolataGo Nerd Font Mono" ];
        size = 10.0;
      };

      bars = [
        {
          command = "waybar";
        }
      ];

      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainbar = {
        layer = "top";
        position = "bottom";
        modules-left = [ "sway/workspaces" ];
        modules-center = [ ];
        modules-right = [ "clock" "battery" ];
        clock = {
          format = "{:%I:%M %p}";
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };
      };
    };
    style = ''
      * {
        font-family: "InconsolataGo Nerd Font Propo";
        font-size: 16px;
      }

      #battery {
        margin-left: 16px;
        margin-right: 8px;
      }
    '';
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "InconsolataGo Nerd Font Mono:size=12";
      };
    };
  };

  home.packages = with pkgs; [
    zoom-us
    chromium
    tmux
    xfce.thunar

    neovim
    gcc # needed for treesitter
    ripgrep # needed for telescope
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Adrian Rocke";
      user.email = "me@adrianrocke.com";
      init.defaultBranch = "main";
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    sway.enable = true;
  };

  # The version this config is compatible with.
  # You shouldn't need to change this when upgrading.
  home.stateVersion = "24.11";
}

