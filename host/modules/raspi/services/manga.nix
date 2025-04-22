{
  config,
  secrets,
  mkLocalNginx,
  ...
}: {
  imports = [
    (mkLocalNginx "manga" config.services.suwayomi-server.settings.server.port true)
  ];

  services.suwayomi-server = {
    enable = true;
    dataDir = "/mnt/main/services/suwayomi";
    settings.server = {
      downloadAsCbz = true;
      port = 10000;
      extensionRepos = [
        "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
        # "https://raw.githubusercontent.com/Kareadita/tachiyomi-extensions/repo/index.min.json"
      ];
    };
  };
}
