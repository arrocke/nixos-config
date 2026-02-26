{ ... }: 

{
  # necessary for wireguard
  boot.kernelModules = [
    "iptable_nat"
    "iptable_filter"
    "xt_nat"
  ];

  networking.firewall = {
    allowedUDPPorts = [
      51820 # WireGuard
    ];
  };

  networking.nat = {
    enable = true;
    externalInterface = "eno1";
    internalInterfaces = [ "wg0" ];
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
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
  };
}
