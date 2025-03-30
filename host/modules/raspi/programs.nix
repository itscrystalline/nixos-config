{
  config,
  pkgs,
  ...
}: {
  imports = [../common/programs.nix];

  environment.systemPackages = with pkgs; [
    libraspberrypi

    doas-sudo-shim
  ];

  # SMTP for Nextcloud
  programs.msmtp = {
    enable = false;
    accounts = {
      default = {
        auth = true;
        tls = true;
        # try setting `tls_starttls` to `false` if sendmail hangs
        from = "${config.services.nextcloud.hostName}";
        host = "<hostname here>";
        user = "<username here>";
        passwordeval = "cat /secrets/smtp_password.txt";
      };
    };
  };
}
