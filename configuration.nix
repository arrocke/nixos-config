# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, secrets, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./modules/audio.nix
      ./modules/secrets.nix
      ./modules/photos.nix
      ./modules/zfs.nix
      ./modules/proxy.nix
      ./modules/postgres.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # necessary for wireguard
  boot.kernelModules = [
    "iptable_nat"
    "iptable_filter"
    "xt_nat"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    chromium
    gcc
    docker-compose
    pgadmin4-desktopmode
    tmux
    tmuxinator
    lsof
    ripgrep
    pciutils
    xfce.thunar
    wireguard-tools
    unzip
  ];

  programs.iotop.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.thunar = {
      enable = true;
  };

  users.users.adrian = {
    isNormalUser = true;
    home = "/home/adrian";
    description = "Adrian Rocke";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCH4qIlPyu8bkbp6WqtoTE4V90LPgSSVKKXsHiCSK+WKAZBrKv//khW+f8EzuRLiW8M8MuzuYKCdusgVb7Ocvg+rakdnfLh26DmMAInocbO9deBVYRIjKREqbo+Ww/+xvqECOn6HEdYPfvkWQ221kBIO1/nctwzCt2VWDZVihgPWh2S4yBbimqqM8gX+QMgS88o3PGmHjtuiowSNGPEkErzc286MGSsZaS8xNsPt3Yf6+Ce3MbJlxZyVJOt+xq+asCvToJVCG4VRbJHVjdfcrjuchw8fy7CTDN1hPEy5H/IOGuvexFJrp/7uG8ES2aKe90tIQoeeSDCEqH3wfU5APVj5HBl6i9YFbqJzzsOsmbjizfgY7lzk6H1Hdfo6OOZZUVhfcbK2Iju77IbHAtTHAqmWDXQ/hlLzsjP5VeEQmTTGYEMcKJ70XRb5XyAsOm8Q1wNyjUN/BjhUbkHrJMEGKSlTRCB7CQyqblFAJPMgIcGWfvthJgIoU0W7Mxo67BnZLzjfi4OahNSqk/YjltYeKpn9kjjZvRqQPNwjO21MH3XC9tr07I8UuG6+R+kWdu13tOrtGXMX5VAkYYHVyrD04mR+rWswUtb4BH13410PFafIrrbLobcwcyvEFZ1j0VRdkyv1a5HnL/hqm2YIXkUTDprUP2zlopMkrWYgGSxe3lww== me@adrianrocke.com"];
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    oci-containers = {
      backend = "docker";
      containers = {
        zwave = {
          image = "zwavejs/zwave-js-ui:10.7.0";
          ports = [ "8091:8091" "3300:3000" ];
          volumes = [
            "/home/adrian/.homeassistant/zwave:/usr/src/app/store"
          ];
          extraOptions = [
            "--device=/dev/serial/by-id/usb-0658_0200-if00:/dev/zwave"
          ];
          environment = {
            TZ = "America/Chicago";
          };
        };
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:stable";
          autoStart = true;
          ports = [ "8123:8123" ];
          volumes = [
            "/home/adrian/.homeassistant:/config"
          ];
          extraOptions = [
            "--network=host"
          ];
          environment = {
            TZ = "America/Chicago";
          };
        };
      };
    };
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [pkgs.brlaser];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    ports = [2022];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["adrian"];
      PermitRootLogin = "no";
    };
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  sops = {
    secrets = {
      no-ip-password = {
        mode = "0440";
        owner = "inadyn";
        group = "inadyn";
      };
    };
  };
  services.inadyn = {
    enable = true;
    interval = "*-*-* *:00,15,30,45:00";
    settings.provider.dyn = {
        include = "/run/secrets/no-ip-password";
        ssl = false;
        username = "wqcam3b";
        hostname = "chadrian.no-ip.org";
    };
  };


  # services.guacamole = {
  #   enable = true;
  #   host = "127.0.0.1";
  #   port = 4822;
  #   userMappingXml = ./user-mapping.xml;
  # }

  # Enable sound.
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  networking.firewall = {
      allowedTCPPorts = [
        2022 # ssh
        8123 # home assistant
        8091 3300 # zwave
        3000 4000 # GBT development
        8888 # DLNA dev
      ];
      allowedUDPPorts = [
        51820 # WireGuard
      ];
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = "eno1";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;

      # Generate keys with
      # umask 077
      # sudo mkdir /etc/wireguard
      # sudo wg genkey > /etc/wireguard/private
      # sudo wg pubkey < /etc/wireguard/private > /etc/wireguard/public

      privateKeyFile = "/etc/wireguard/private";
      peers = [
        { 
          name = "phone-adrian";
          publicKey = "ozsEzWrbSBx912IkZla4N7wKdnWEgBTR8UZEENY0fBA=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { 
          name = "phone-charity";
          publicKey = "x0mktTFVVnmvuDepa8OmXJtwI406bwvDXW6BAvbVK3w=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        { 
          name = "macbook-adrian";
          publicKey = "0l7s1xf+7s3dMFT0d8nHyzwqi/7kg6voiwDWKXzCoXM=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
      ];
    };
  };

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

