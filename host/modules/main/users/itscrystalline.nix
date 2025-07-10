{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [../../common/users/itscrystalline.nix];

  users.users.itscrystalline.extraGroups = ["libvirtd" "dialout" "ydotool" "dumpcap" "wireshark" "docker"];
  # PFP
  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${./itscrystalline.png} /var/lib/AccountsService/icons/itscrystalline
    cp ${./itscrystalline.png} /home/itscrystalline/.face
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/itscrystalline\n" > /var/lib/AccountsService/users/itscrystalline
  '';
  services.displayManager.defaultSession = "hyprland-uwsm";

  # k3d cpuset cgroup workaround https://github.com/NixOS/nixpkgs/issues/385044#issuecomment-2682670249
  systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";
}
