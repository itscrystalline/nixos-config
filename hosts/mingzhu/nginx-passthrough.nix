_: let
  raine_ip = "100.125.37.13";
in {
  services.nginx.streamConfig = ''
    map $ssl_preread_server_name $backend {
      git.iw2tryhard.dev  ${raine_ip}:443;
    }

    server {
      listen 443;
      ssl_preread on;
      proxy_pass $backend;
    }
    server {
      listen 2222;
      proxy_pass ${raine_ip}:2222;
    }
  '';

  crystals-services.network.ports.tcp = [2222];
}
