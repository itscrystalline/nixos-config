{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.virtualisation;
in {
  options.crystal.virtualisation.enable = lib.mkEnableOption "virtualisation";
  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;

    boot = {
      # OSX-KVM
      extraModprobeConfig = ''
        options kvm_intel nested=1
        options kvm_intel emulate_invalid_guest_state=0
        options kvm ignore_msrs=1
      '';
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"

        "i915"
      ];
      kernelParams = ["intel_iommu=on" "vfio-pci.ids=8086:9bc4"];
    };

    networking.firewall.trustedInterfaces = ["virbr0"];

    environment.systemPackages = [pkgs.distrobox];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          vhostUserPackages = with pkgs; [virtiofsd];
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
      docker = {
        enable = true;
        enableOnBoot = true;
      };
    };
  };
}
