{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80 # HTTP
    443 # HTTPS
    53 # DNS
  ];
  networking.firewall.allowedUDPPorts = [
    53 # DNS
  ];

  sops = {
    secrets = {
      caddy-env = {
        mode = "0440";
        owner = "caddy";
        group = "caddy";
      };
    };
  };
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.3" ];
      hash = "sha256-eDCHOuPm+o3mW7y8nSaTnabmB/msw6y2ZUoGu56uvK0=";
    };
    virtualHosts."*.rocke.dev" = {
      extraConfig = ''
        tls {
          dns cloudflare {$CLOUDFLARE_API_KEY}
          resolvers 1.1.1.1
        }
      '';
    };
    environmentFile = "/run/secrets/caddy-env";
  };

  services.unbound = {
    enable = true;

    settings = {
      server = {
        interface = [ "0.0.0.0" "127.0.0.1" ];
        access-control = [
          "192.168.0.0/24 allow"
          "10.100.0.0/24 allow"
        ];
        access-control-view = [
          "127.0.0.1 lan"
          "192.168.0.0/24 lan"
          "10.100.0.0/24 vpn"
        ];
      };

      view = [
        {
          name = "lan";
          local-zone = [''"rocke.dev." redirect''];
          local-data = [
            ''"rocke.dev. 60 IN A 192.168.0.11"''
          ];
        }
        {
          name = "vpn";
          local-zone = [''"rocke.dev." redirect''];
          local-data = [
            ''"rocke.dev. 60 IN A 10.100.0.1"''
          ];
        }
      ];
    };
  };
}
