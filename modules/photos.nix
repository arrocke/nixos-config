{ ... }:

{
  services.minidlna = {
    enable = true;
    settings = {
      media_dir = ["/data/media"];
      inotify = "yes";
    };
  };
  networking.firewall.allowedTCPPorts = [8200];
  networking.firewall.allowedUDPPorts = [1900];

  services.immich = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
  };
}
