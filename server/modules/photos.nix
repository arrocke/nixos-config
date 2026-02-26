{ ... }:

{
  services.immich = {
      enable = true;
      host = "0.0.0.0";
  };
  services.caddy.virtualHosts."immich.rocke.dev" = {
    extraConfig = ''
      reverse_proxy http://localhost:2283
    '';
  };

  sops = {
    secrets = {
      immich-api-key = {
        mode = "0440";
        owner = "immich";
        group = "immich";
      };
    };
  };
  services.immich-dlna = {
      enable = true;
      immichApiKeyFile = /run/secrets/immich-api-key;
      port = 8200;
      dlnaOrigin = "http://192.168.0.11:8200";
      # Ideally, we'd put this behind a proxy, but libupnp makes that difficult
      openFirewall = true;
  };
}
