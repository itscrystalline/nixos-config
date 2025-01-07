{ config, pkgs, ... }@inputs:
{
  networking.hostName = "cwystaws-meowchine";
  networking.networkmanager.enable = true;
}
