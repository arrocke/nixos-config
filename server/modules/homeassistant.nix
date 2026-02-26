{ ... }:

{
  networking.firewall.allowedTCPPorts = [
    8123 # home assistant
    8091 # zwave
  ];

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    oci-containers = {
      backend = "docker";
      containers = {
        zwave = {
          image = "zwavejs/zwave-js-ui:11.12.0";
          ports = [ "8091:8091" "3300:3000" ];
          volumes = [
            "/home/adrian/.homeassistant/zwave:/usr/src/app/store"
          ];
          extraOptions = [
            "--device=/dev/serial/by-id/usb-0658_0200-if00:/dev/zwave"
          ];
          environment = {
            TZ = "America/Chicago";
          };
        };
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:2026.2";
          autoStart = true;
          ports = [ "8123:8123" ];
          volumes = [
            "/home/adrian/.homeassistant:/config"
          ];
          extraOptions = [
            "--network=host"
          ];
          environment = {
            TZ = "America/Chicago";
          };
        };
      };
    };
  };
}
