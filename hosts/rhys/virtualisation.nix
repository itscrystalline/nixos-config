{
  pkgs,
  config,
  ...
}: {
  programs.virt-manager.enable = true;
  kernel = {
    modprobeConfig = [
      ''
        options kvm_intel nested=1
        options kvm_intel emulate_invalid_guest_state=0
        options kvm ignore_msrs=1
      ''
    ];
    cmdline = ["intel_iommu=on" "vfio-pci.ids=8086:9bc4"];
  };

  boot.stage1AvailableModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"

    "i915"
  ];

  network.trustedInterfaces = ["virbr0"];

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
  };

  users.users.${config.core.primaryUser}.extraGroups = ["libvirtd"];
}
