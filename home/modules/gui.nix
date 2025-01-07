{ config, pkgs, zen-browser, ... }@inputs:
{
  home.packages = with pkgs; [
    unstable.ghostty
    vesktop # discor
    teams-for-linux # teams :vomit:
    ytmdesktop # YT Music
    keepassxc
    teamviewer
  ] ++ [ zen-browser.packages.${pkgs.system}.default ];
}
