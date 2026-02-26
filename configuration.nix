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
      ./modules/vpn.nix
      ./modules/ddns.nix
      ./modules/homeassistant.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    gcc
    lsof
    pciutils
  ];

  programs.iotop.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  users.users.adrian = {
    isNormalUser = true;
    home = "/home/adrian";
    description = "Adrian Rocke";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCH4qIlPyu8bkbp6WqtoTE4V90LPgSSVKKXsHiCSK+WKAZBrKv//khW+f8EzuRLiW8M8MuzuYKCdusgVb7Ocvg+rakdnfLh26DmMAInocbO9deBVYRIjKREqbo+Ww/+xvqECOn6HEdYPfvkWQ221kBIO1/nctwzCt2VWDZVihgPWh2S4yBbimqqM8gX+QMgS88o3PGmHjtuiowSNGPEkErzc286MGSsZaS8xNsPt3Yf6+Ce3MbJlxZyVJOt+xq+asCvToJVCG4VRbJHVjdfcrjuchw8fy7CTDN1hPEy5H/IOGuvexFJrp/7uG8ES2aKe90tIQoeeSDCEqH3wfU5APVj5HBl6i9YFbqJzzsOsmbjizfgY7lzk6H1Hdfo6OOZZUVhfcbK2Iju77IbHAtTHAqmWDXQ/hlLzsjP5VeEQmTTGYEMcKJ70XRb5XyAsOm8Q1wNyjUN/BjhUbkHrJMEGKSlTRCB7CQyqblFAJPMgIcGWfvthJgIoU0W7Mxo67BnZLzjfi4OahNSqk/YjltYeKpn9kjjZvRqQPNwjO21MH3XC9tr07I8UuG6+R+kWdu13tOrtGXMX5VAkYYHVyrD04mR+rWswUtb4BH13410PFafIrrbLobcwcyvEFZ1j0VRdkyv1a5HnL/hqm2YIXkUTDprUP2zlopMkrWYgGSxe3lww== me@adrianrocke.com"];
  };


  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/Chicago";

  services.dbus.enable = true;

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

  networking.firewall = {
      allowedTCPPorts = [
        2022 # ssh
      ];
  };

  system.stateVersion = "25.05";
}

