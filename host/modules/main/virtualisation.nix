{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = with pkgs; [virtiofsd];
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = [pkgs.distrobox];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
