{
  config,
  mkLocalNginx,
  ...
}: let
  port = 8501;
in {
  imports = [
    (mkLocalNginx "cache" port true)
  ];

  services.ncps = {
    enable = true;
    cache = {
      inherit (config.networking) hostName;
      dataPath = "/mnt/main/ncps/data";
      tempPath = "/mnt/main/ncps/temp";
      databaseURL = "sqlite:/mnt/main/ncps/db/db.sqlite";
      maxSize = "100G";
      lru.schedule = "0 2 * * *";
      allowPutVerb = true;
      allowDeleteVerb = true;
    };
    server.addr = "0.0.0.0:${builtins.toString port}";
    upstream = {
      caches = config.nix.settings.substituters;
      publicKeys = config.nix.settings.trusted-public-keys;
    };
  };
}
