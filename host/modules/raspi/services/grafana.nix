{
  config,
  pkgs,
  secrets,
  mkLocalNginx,
}: {
  imports = [
    (mkLocalNginx "grafana" config.services.grafana.settings.server.http_port true)
    (mkLocalNginx "prometheus" config.services.prometheus.port false)
    (mkLocalNginx "loki" config.services.loki.configuration.server.http_listen_port false)
    (mkLocalNginx "promtail" config.services.promtail.configuration.server.http_listen_port false)
  ];

  services.grafana = {
    enable = true;

    settings.server = {
      http_port = 9000;
      http_addr = "0.0.0.0";
      protocol = "http";
      domain = "grafana.crys";
      enforce_domain = true;
    };
    settings.analytics.reporting_enabled = false;

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
          jsonData = {
            timeout = 2 * 60;
          };
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        }
      ];
    };
  };
  services.prometheus = {
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
      nextcloud = {
        enable = true;
        port = 9013;
        url = "https://${config.services.nextcloud.hostName}";
        tokenFile = "${pkgs.writeText "nc_token" secrets.nextcloud.admin.stats_token}";
      };
    };

    scrapeConfigs = [
      {
        job_name = "raspi";
        static_configs = [
          {
            targets = map (port: "127.0.0.1:${toString port}") (with config.services.prometheus.exporters; [node.port smartctl.port nextcloud.port]);
          }
        ];
      }
    ];
  };
  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 9020;
      auth_enabled = false;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
        # max_retries = 0;
      };

      schema_config = {
        configs = [
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
      };

      storage_config = {
        tsdb_shipper = {
          active_index_directory = "/var/lib/loki/tsdb-active";
          cache_location = "/var/lib/loki/tsdb-cache";
          cache_ttl = "24h";
          # shared_store = "filesystem";
        };
        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
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
        # shared_store = "filesystem";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 9040;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
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
              host = "${config.networking.hostName}";
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
    # extraFlags
  };
}
