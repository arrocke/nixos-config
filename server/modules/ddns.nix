{ config, ... }:

{
  sops.secrets.cloudflare-api-key = {
    restartUnits = [ "ddclient.service" ];
  };
  services.ddclient = {
    enable = true;
    interval = "5min";
    protocol = "cloudflare";
    
    username = "token"; 
    passwordFile = config.sops.secrets.cloudflare-api-key.path;
    
    # Target configurations
    zone = "rocke.dev";
    domains = [ "vpn.rocke.dev" ];
    ssl = true;
  };
}
