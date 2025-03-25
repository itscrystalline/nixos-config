{...}: {
  virtualisation.docker = {
    enable = false; # change this later
    daemon.settings = {
      data-root = "/mnt/main/docker";
    };
  };
}
