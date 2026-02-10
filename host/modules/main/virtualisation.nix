{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.virtualisation;
in {
  options.crystal.virtualisation.enable = lib.mkEnableOption "virtualisation" // {default = true;};
  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.vhostUserPackages = with pkgs; [virtiofsd];
    virtualisation.spiceUSBRedirection.enable = true;

    virtualisation.virtualbox.host.enable = true;
    # virtualisation.virtualbox.host.enableKvm = true;
    # virtualisation.virtualbox.host.addNetworkInterface = false;

    # OSX-KVM
    boot.extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    environment.systemPackages = [pkgs.distrobox];
    # virtualisation.podman = {
    #   enable = true;
    #   dockerCompat = true;
    #   defaultNetwork.settings.dns_enabled = true;
    # };
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      #   # daemon.settings = {
      #   #   dns = ["1.1.1.1" "1.0.0.1" "8.8.8.8"];
      #   # };
      # };
    };
  };
}
