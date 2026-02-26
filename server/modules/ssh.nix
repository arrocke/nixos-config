{ ... }:

{
  networking.firewall.allowedTCPPorts = [
    22 # ssh
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
