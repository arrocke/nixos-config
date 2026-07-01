{ pkgs, ... }:
{
  # tty2 to separates boot logs from greeter. Use alt + F2 to see boot logs.
  boot.kernelParams = [
    "console=tty2"
  ];

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
