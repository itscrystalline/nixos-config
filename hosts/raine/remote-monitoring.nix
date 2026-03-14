_: {
  services.prometheus.scrapeConfigs = [
    {
      job_name = "blocky";
      static_configs = [{targets = ["100.95.62.30:5000"];}];
    }
    {
      job_name = "ncps";
      static_configs = [{targets = ["100.95.62.30:8501"];}];
      scrape_interval = "30s";
    }
    {
      job_name = "harmonia";
      static_configs = [{targets = ["100.95.62.30:8502"];}];
    }
  ];
}
