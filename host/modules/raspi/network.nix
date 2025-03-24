{ config, pkgs, ... }@inputs:
{
  imports = [
    ../common/network.nix
  ];

  networking.hostName = "cwystaws-raspi";

}

