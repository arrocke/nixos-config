{ ... }:

{
  services.caddy = {
    enable = true;
  };
  security.pki.certificateFiles = [
    ../caddy-ca.crt
  ];

  networking.firewall.allowedTCPPorts = [80 443];

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
