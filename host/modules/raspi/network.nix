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
}
