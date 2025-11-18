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
      caches = [
        "https://devenv.cachix.org"
        "https://sanzenvim.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-python.cachix.org"
      ];
      publicKeys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "sanzenvim.cachix.org-1:zNf9OhUUfJ/NM55vbjx9fSM6O/Q3L6JDoFwU1VCEohc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
      ];
    };
  };
}
