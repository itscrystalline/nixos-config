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
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   defaultNetwork.settings.dns_enabled = true;
  # };
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    # daemon.settings = {
    #   dns = ["1.1.1.1" "1.0.0.1" "8.8.8.8"];
    # };
  };
}
