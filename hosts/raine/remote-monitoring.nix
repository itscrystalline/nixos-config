_: {
  services.prometheus.scrapeConfigs = [
    {
      job_name = "blocky";
      static_configs = [{targets = ["100.95.62.30:5000"];}];
    }
    {
      job_name = "ncps";
      scheme = "http";
      static_configs = [{targets = ["cache.crys"];}];
      scrape_interval = "30s";
    }
    {
      job_name = "harmonia";
      scheme = "http";
      static_configs = [{targets = ["harmonia.cache.crys"];}];
    }
  ];
}
