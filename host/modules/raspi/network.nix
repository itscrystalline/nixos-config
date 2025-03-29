{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ../common/network.nix
  ];

  networking.hostName = "cwystaws-raspi";
  networking.networkmanager.wifi.powersave = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443 8080];
  };
}
