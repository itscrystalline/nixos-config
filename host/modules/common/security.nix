{
  config,
  pkgs,
  ...
} @ inputs: {
  environment.systemPackages = with pkgs; [
    git-crypt
  ];

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = ["itscrystalline"];
      # Optional, retains environment variables while running commands
      # e.g. retains your NIX_PATH when applying your config
      keepEnv = true;
      persist = true; # Optional, only require password verification a single time
    }
  ];

  # use gnome polkit (req. for hyprland)
  security.polkit = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
