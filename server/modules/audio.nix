{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
  };
}
