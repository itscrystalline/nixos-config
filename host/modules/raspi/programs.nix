{
  config,
  pkgs,
  secrets,
  ...
}: {
  imports = [../common/programs.nix];

  environment.systemPackages = with pkgs; [
    libraspberrypi

    doas-sudo-shim
  ];

  # SMTP for Nextcloud
  programs.msmtp = with secrets.mailjet; {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        # try setting `tls_starttls` to `false` if sendmail hangs
        user = api_key;
        password = secret_key;
        host = "in-v3.mailjet.com";
        port = 587;
        from = "nc@iw2tryhard.dev";
      };
    };
  };
}
