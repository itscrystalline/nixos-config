{
  lib,
  config,
  ...
}: {
  options.crystals-services.msmtp.enable = lib.mkEnableOption "msmtp mailer";
  config.programs.msmtp = lib.mkIf config.crystals-services.msmtp.enable {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        user = "choyrumthad";
        passwordeval = "cat ${config.sops.secrets."mail-password".path}";
        host = "smtp.gmail.com";
        port = 587;
        from = "nc@iw2tryhard.dev";
      };
    };
  };
}
