{ config, pkgs, ... }@inputs:
{
  users.users.itscrystalline = {
    isNormalUser = true;
    description = "itscrystalline";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "dialout" ];
    shell = pkgs.zsh;
  };
  # PFP
  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${./itscrystalline.png} /var/lib/AccountsService/icons/itscrystalline
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/itscrystalline\n" > /var/lib/AccountsService/users/itscrystalline
  '';
  services.displayManager.defaultSession = "hyprland-uwsm";
}
