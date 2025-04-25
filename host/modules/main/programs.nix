{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [../common/programs.nix];

  programs.firefox.enable = true;

  programs.binary-ninja.enable = true;

  environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = pkgs.lib.mkForce "${pkgs.nautilus-python}/lib/nautilus/extensions-4";

  # open any terminal in nautilus
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    polkit_gnome
    gnome-keyring
    # open any term
    nautilus-python
  ];
  # powerManagement.powertop.enable = true;
  programs.ydotool.enable = true;
}
