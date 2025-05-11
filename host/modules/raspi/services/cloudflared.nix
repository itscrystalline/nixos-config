{lib, ...}: {
  services.cloudflared = let
    secret_path = builtins.toPath ../../../../secrets/cfd_creds.json;
    mkDomains = attrs:
      lib.mergeAttrsList (map (key: {
        "${key}${
          if key != ""
          then "."
          else ""
        }iw2tryhard.dev" =
          attrs."${key}"
          // {
            service = "http://localhost:80";
          };
      }) (builtins.attrNames attrs));
  in {
    enable = true;
    tunnels = {
      "fc4d0058-a84e-4ef5-b66f-56c2a1a7eb7f" = {
        credentialsFile = "${secret_path}";
        ingress = mkDomains {
          "" = {};
          "www" = {};
          "v2" = {};
          "nc".originRequest = {
            disableChunkedEncoding = true;
            # http2Origin = true;
            noHappyEyeballs = true;
            noTLSVerify = true;
          };
          # "collabora" = {};
        };
        warp-routing.enabled = false;
        default = "http_status:404";
      };
    };
  };
}
