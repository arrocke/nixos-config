{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    makemkv
    vlc
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Enables makemkv to read optical drives and write them to the jellyfin media directories
  boot.kernelModules = ["sg"];
  users.users.adrian.extraGroups = ["cdrom" "jellyfin"];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/media 0770 jellyfin jellyfin -"
    "d /var/lib/jellyfin 0770 jellyfin jellyfin -"
  ];
  services.caddy.virtualHosts."jellyfin.rocke.dev" = {
    extraConfig = ''
      reverse_proxy http://localhost:8096
    '';
  };
}
