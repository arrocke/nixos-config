{ ... }:

{
  sops = {
    secrets = {
      no-ip-password = {
        mode = "0440";
        owner = "inadyn";
        group = "inadyn";
      };
    };
  };
  services.inadyn = {
    enable = true;
    interval = "*-*-* *:00,15,30,45:00";
    settings.provider.dyn = {
        include = "/run/secrets/no-ip-password";
        ssl = false;
        username = "wqcam3b";
        hostname = "chadrian.no-ip.org";
    };
  };
}
