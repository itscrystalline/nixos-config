_: {
  services.prometheus.scrapeConfigs = [
    {
      job_name = "blocky";
      static_configs = [{targets = ["100.95.62.30:5000"];}];
    }
  ];
}
