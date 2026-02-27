{ config, lib, pkgs, ... }:

{ imports = [
    ./hardware-configuration.nix
    ../shared/secrets.nix
    ../shared/audio.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true; boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  # TODO: in the next nixos version, convert this to generateHostKeys = true to just create the host key without enabling the ssh daemon.
  services.openssh.enable = true;

  users.users.adrian = {
    isNormalUser = true;
    home = "/home/adrian";
    description = "Adrian Rocke";
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" ];
  };

  security.polkit.enable = true;
  hardware.graphics.enable = true;
  services.libinput.enabled = true;

  fonts.packages = with pkgs; [
    inconsolata
  ];

  virtualisation.docker.enable = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 36 * 1024; # 36GB in MB, just a bit bigger than RAM
    }
  ];

  powerManagement.enable = true;

  boot.kernelParams = [
    "resume_offset=220305408"
    "mem_sleep_default=deep" # Suspend first
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/df9c547e-952e-44da-94eb-626d6c5013cf";

  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };

  # Define time delay for hibernation after suspending
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20m
  '';

  # Enable CUPS to print documents. services.printing.enable = true;

  # Enable sound. services.pulseaudio.enable = true; OR services.pipewire = {
  #   enable = true; pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager). services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’. users.users.alice = {
  #   isNormalUser = true; extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user. packages = with pkgs; [
  #     tree ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile. You can use https://search.nixos.org/ to find more packages (and options). environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default. wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions. programs.mtr.enable = true; programs.gnupg.agent = {
  #   enable = true; enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon. services.openssh.enable = true;

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall altogether. 
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system (/run/current-system/configuration.nix). This is useful in case you accidentally delete 
  # configuration.nix. system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine, and is used to maintain compatibility with application data (e.g. 
  # databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason, even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from, so changing it will NOT upgrade your system - see 
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration, and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

