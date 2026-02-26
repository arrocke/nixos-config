{ ... }:

{
  sops = {
    secrets = {
      zfs-key = {
        mode = "0440";
        owner = "root";
        group = "root";
      };
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "184b5ac9";

  services.zfs.autoScrub.enable = true;

  services.sanoid = {
    enable = true;
    templates.backup = {
      hourly = 36;
      daily = 30;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };

    datasets."zdata" = {
      useTemplate = [ "backup" ];
    };
  };
}

