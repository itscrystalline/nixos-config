_: {
  imports = [./disko.nix ./facter.nix];
  services.logind.settings.Login.HandleLidSwitch = "ignore";
}
