{pkgs, ...}: {
  imports = [../common/programs.nix];

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];
}
