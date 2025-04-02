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
  programs.msmtp = let
    mailjet_api_key = builtins.readFile ../../../secrets/mailjet_api_key;
    mailjet_secret_key = builtins.readFile ../../../secrets/mailjet_secret_key;
  in {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        # try setting `tls_starttls` to `false` if sendmail hangs
        user = mailjet_api_key;
        password = mailjet_secret_key;
        host = "in-v3.mailjet.com";
        port = 587;
        from = "nc@iw2tryhard.dev";
      };
    };
  };
}
