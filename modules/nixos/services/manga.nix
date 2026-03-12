{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) manga;
  inherit (config.crystals-services.nginx) localSuffix;
  enabled = manga.enable;
in {
  options.crystals-services.manga.enable = lib.mkEnableOption "Suwayomi manga server";
  config = lib.mkIf enabled {
    services.suwayomi-server = {
      enable = true;
      dataDir = "/mnt/main/services/suwayomi";
      settings.server = {
        downloadAsCbz = true;
        port = 10000;
        extensionRepos = [
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
        ];
      };
    };
    services.nginx.virtualHosts."manga.${localSuffix}".locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.suwayomi-server.settings.server.port}";
      proxyWebsockets = true;
    };
  };
}
