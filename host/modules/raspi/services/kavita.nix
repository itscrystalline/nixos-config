{
  config,
  secrets,
  mkLocalNginx,
  ...
}: {
  imports = [
    (mkLocalNginx "manga" config.services.kavita.settings.Port false)
  ];

  services.kavita = {
    enable = true;
    dataDir = "/mnt/main/services/kavita";
    tokenKeyFile = ../../../secrets/kavita_token_key;
    settings.Port = 10000;
  };
  virtualisation.oci-containers.containers = {
    komf = {
      image = "sndxr/komf:latest";
      ports = ["127.0.0.1::8085"];
      user = "1000:1000";
      extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
      autoStart = true;
      environment = {
        KOMF_KAVITA_BASE_URI = "http://127.0.0.1:${config.services.kavita.settings.Port}";
        KOMF_KAVITA_API_KEY = secrets.kavita_api_key;
        KOMF_LOG_LEVEL = "INFO";
        JAVA_TOOL_OPTIONS = "-XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:ShenandoahGCHeuristics=compact -XX:ShenandoahGuaranteedGCInterval=3600000 -XX:TrimNativeHeapInterval=3600000";
      };
      volumes = [
        "/mnt/main/services/komf:/config"
      ];
    };
  };
}
