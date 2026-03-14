{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) monitoring;
  inherit (config.crystals-services.nginx) localSuffix;
  enabled = monitoring.enable;
in {
  options.crystals-services.monitoring = {
    enable = lib.mkEnableOption "Grafana + Prometheus + Loki + Promtail monitoring stack";
    enableOpenTelemetryCollector = lib.mkEnableOption "OpenTelemetry Collector";
  };
  config = lib.mkIf enabled {
    services = {
      grafana = {
        enable = true;
        declarativePlugins = with pkgs.grafanaPlugins; [grafana-piechart-panel];
        settings = {
          server = {
            http_port = 9000;
            http_addr = "0.0.0.0";
            protocol = "http";
            domain = "grafana.${localSuffix}";
            enforce_domain = true;
          };
          analytics.reporting_enabled = false;
          panels.disable_sanitize_html = true;
        };
        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            }
            {
              name = "Loki";
              type = "loki";
              access = "proxy";
              jsonData.timeout = 2 * 60;
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
            }
          ];
        };
      };

      prometheus = {
        enable = true;
        port = 9010;
        exporters = {
          node = {
            enable = true;
            enabledCollectors = ["systemd" "processes" "pressure" "tcpstat" "interrupts"];
            port = 9011;
          };
          smartctl = {
            enable = true;
            port = 9012;
            devices = ["/dev/disk/by-id/ata-TOSHIBA_MQ04UBF100_15QPP0JDT"];
          };
          nextcloud = lib.mkIf config.crystals-services.nextcloud.enable {
            enable = true;
            port = 9013;
            url = "https://${config.services.nextcloud.hostName}";
            tokenFile = config.crystals-services.nextcloud.statsTokenFile;
          };
        };
        scrapeConfigs =
          [
            {
              job_name = "raine";
              static_configs = [
                {
                  targets = map (port: "127.0.0.1:${toString port}") (with config.services.prometheus.exporters; [node.port smartctl.port]);
                }
              ];
            }
          ]
          ++ lib.optional config.crystals-services.nextcloud.enable {
            job_name = "nextcloud";
            static_configs = [{targets = ["127.0.0.1:${toString config.services.prometheus.exporters.nextcloud.port}"];}];
          }
          ++ lib.optional config.crystals-services.blocky.enable {
            job_name = "blocky";
            static_configs = [{targets = ["127.0.0.1:${toString config.services.blocky.settings.ports.http}"];}];
          };
      };

      loki = {
        enable = true;
        configuration = {
          server.http_listen_port = 9020;
          auth_enabled = false;
          ingester = {
            lifecycler = {
              address = "127.0.0.1";
              ring = {
                kvstore.store = "inmemory";
                replication_factor = 1;
              };
            };
            chunk_idle_period = "1h";
            max_chunk_age = "1h";
            chunk_target_size = 999999;
            chunk_retain_period = "30s";
          };
          schema_config.configs = [
            {
              from = "2025-04-02";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
          storage_config = {
            tsdb_shipper = {
              active_index_directory = "/var/lib/loki/tsdb-active";
              cache_location = "/var/lib/loki/tsdb-cache";
              cache_ttl = "24h";
            };
            filesystem.directory = "/var/lib/loki/chunks";
          };
          limits_config = {
            reject_old_samples = true;
            reject_old_samples_max_age = "168h";
          };
          table_manager = {
            retention_deletes_enabled = false;
            retention_period = "0s";
          };
          compactor = {
            working_directory = "/var/lib/loki";
            compactor_ring.kvstore.store = "inmemory";
          };
        };
      };

      promtail = {
        enable = true;
        configuration = {
          server = {
            http_listen_port = 9040;
            grpc_listen_port = 0;
          };
          positions.filename = "/tmp/positions.yaml";
          clients = [
            {
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
            }
          ];
          scrape_configs = [
            {
              job_name = "journal";
              journal = {
                max_age = "12h";
                labels = {
                  job = "systemd-journal";
                  host = config.networking.hostName;
                };
              };
              relabel_configs = [
                {
                  source_labels = ["__journal__systemd_unit"];
                  target_label = "unit";
                }
              ];
            }
          ];
        };
      };

      nginx.virtualHosts = {
        "grafana.${localSuffix}".locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
        };
        "prometheus.${localSuffix}".locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
        };
        "loki.${localSuffix}".locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        };
        "promtail.${localSuffix}".locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.promtail.configuration.server.http_listen_port}";
        };
      };
    };

    systemd.services.otel-collector = let
      otel-config = lib.generators.toYAML {} {
        exporters.debug.verbosity = "detailed";

        processors.batch = {
          send_batch_size = 512;
          timeout = "5s";
        };

        receivers.otlp.protocols = {
          grpc.endpoint = "0.0.0.0:4317";
          http.endpoint = "0.0.0.0:4318";
        };

        service.pipelines = {
          logs = {
            exporters = ["logging"];
            processors = ["batch"];
            receivers = ["otlp"];
          };
          metrics = {
            exporters = ["logging"];
            processors = ["batch"];
            receivers = ["otlp"];
          };
          traces = {
            exporters = ["logging"];
            processors = ["batch"];
            receivers = ["otlp"];
          };
        };
      };
      config-file = pkgs.writeText "otel-collector-config.yaml" otel-config;
    in
      lib.mkIf monitoring.enableOpenTelemetryCollector {
        description = "OpenTelemetry Collector";
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        wants = ["network-online.target"];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.opentelemetry-collector-contrib} --config=${config-file}";
          Restart = "always";
          RestartSec = "5s";

          # Security
          PrivateTmp = true;
          NoNewPrivileges = true;
          DynamicUser = true;

          # Resource limits
          LimitNOFILE = 65536;
          MemoryLimit = "512M";
        };

        environment = {
          GOGC = "80";
        };
      };

    network.tcp = lib.mkIf monitoring.enableOpenTelemetryCollector [4317 4318];
  };
}
