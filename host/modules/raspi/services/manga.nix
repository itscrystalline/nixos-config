{
  inputs,
  config,
  secrets,
  mkLocalNginx,
  ...
}: {
  imports = [
    (mkLocalNginx "manga" config.services.suwayomi-server.settings.server.port true)
  ];

  nixpkgs.overlays = [
    (final: prev: {
      suwayomi-server = (import inputs.suwayomi {
        config.allowUnfree = true;
        system = prev.system;
      }).suwayomi-server;
    })
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
