{config, ...}: let
  inherit (config.core) primaryUser;
in {
  users.users.${primaryUser}.extraGroups = ["dialout"];
  # PFP
  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${./itscrystalline.png} /var/lib/AccountsService/icons/${primaryUser}
    cp ${./itscrystalline.png} /home/${primaryUser}/.face
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${primaryUser}\n" > /var/lib/AccountsService/users/${primaryUser}
  '';

  # Virtualisation home-manager config (virt-manager dconf + packages).
  home-manager.users.${primaryUser} = {pkgs, ...}: {
    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    home.packages = with pkgs; [
      qemu-user
      unstable.winboat
    ];
  };
}
