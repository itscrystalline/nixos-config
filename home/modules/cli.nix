{ config, pkgs, home, ... }@inputs:
{
  home.packages = with pkgs; [
    copyq
    grim
    hyprpicker
    slurp
    wl-clipboard
    blahaj
    alsa-utils
    unstable.ghostty
    zoxide
  ];

  home.shellAliases = {
    sudo = "doas";
    svim = "doas nvim";
    update = "sudo nh os switch ~/nixos-config -R";
    nuke-cache = "sudo rm -rf ~/.cache/nix";
    gc = "sudo nh clean all";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      append = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    initExtra = ''
      hyfetch
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
     name = "Jetbrains Mono";
     size = 11;
    };
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };

  # fetches
  programs.fastfetch.enable = true;
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transfeminine";
	    mode = "rgb";
	    light_dark = "dark";
	    lightness = 0.65;
	    color_align = {
		    mode = "horizontal";
		    custom_colors = [];
		    fore_back = [];
	    };
	    backend = "fastfetch";
	    args = null;
	    distro = null;
	    pride_month_shown = [];
	    pride_month_disable = false;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  programs.btop = {
    enable = true;
    settings = {
        update_ms = 200;
    };
  };

  programs.yt-dlp = {
    enable = true;
    package = pkgs.unstable.yt-dlp;
  };

  xdg.configFile."ghostty/catppuccin-mocha".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/ghostty/refs/heads/main/themes/catppuccin-mocha.conf";
    hash = "sha256-ObWG1CqlSc79FayG7WpIetpYb/gsY4FZ9KPo44VByGk=";
  };
  xdg.configFile."ghostty/config".text = ''
    config-file = catppuccin-mocha
    font-family = JetBrainsMono Nerd Font
    font-size = 11
  '';
}
