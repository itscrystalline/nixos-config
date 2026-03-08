{config, ...}: {
  hm = {
    core.username = "opc";
    theming.enable = true;
    programs = {
      cli = {
        enable = true;
        dev.enable = true;
        dev.ai.enable = true;
        fastfetch.profile = "minimal";
      };
      ides.enable = true;
      ssh.hosts = {
        rhys = {
          user = "itscrystalline";
          publicKeyPath = "${config.home.homeDirectory}/.ssh/rhys.pub";
          privateKeyPath = "${config.home.homeDirectory}/.ssh/rhys";
        };
        liriel = {
          user = "itscrystalline";
          publicKeyPath = "${config.home.homeDirectory}/.ssh/liriel.pub";
          privateKeyPath = "${config.home.homeDirectory}/.ssh/liriel";
        };
        raine = {
          user = "itscrystalline";
          publicKeyPath = "${config.home.homeDirectory}/.ssh/raine.pub";
          privateKeyPath = "${config.home.homeDirectory}/.ssh/raine";
        };
        oracle-cloud = {
          hostname = "cwystaws-siwwybowox";
          user = "opc";
          publicKeyPath = "${config.home.homeDirectory}/.ssh/oracle_cloud.pub";
          privateKeyPath = "${config.home.homeDirectory}/.ssh/oracle_cloud";
        };
      };
    };
  };
}
