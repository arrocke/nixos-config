{ config, lib, pkgs, ... }:

{
  programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
  };

  wayland.windowManager.sway = {
    enable = true;

    config = let
      modifier = "Mod4"
    in {
      modifier = modifier;

      keybindings = lib.mkOptionDefault {
        # Super + Shift + S
        # Screenshot a selection that saves to ~/Screenshots and copies to clipboard.
        "${modifier}+Shift+s" = "exec selection=$(slurp) && grim -g \"$selection\" - | tee ~/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
      
        # Print Screen Button
        # Screenshot the currently focused screen, save to ~/Screenshots and copy to clipboard.
        "Print" = "exec grimshot save output - | tee ~/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
      };

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

      terminal = "ghostty";
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

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    sway.enable = true;
  };
}
