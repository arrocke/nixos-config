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
      hourly = 48;
      daily = 30;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };

    datasets."zdata/immich" = {
      # Run daily and monthly snapshots at 2 am
      # to allow immich to create db backups first.
      daily_hour = 2;
      daily_min = 0;
      monthly_hour = 2;
      monthly_min = 0;

      hourly = 48;
      daily = 30;
      weekly = 12;
      monthly = 6;
      yearly = 1;
      autoprune = true;
      autosnap = true;
    };

    datasets."backup/immich" = {
      hourly = 0;
      daily = 60;
      weekly = 52;
      monthly = 72;
      yearly = 10;
      autoprune = true;
      autosnap = false;
    };
  };
}

