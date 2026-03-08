{
  lib,
  config,
  pkgs,
  inputs ? {},
  ...
}: let
  inherit (config.hm.programs) ides;
  inherit (inputs) sanzenvim my-nur;
  enabled = ides.enable;
  sanzenvim-prefix =
    if enabled
    then "default"
    else "mini";
  sanzenvim-pkgs = sanzenvim.packages.${pkgs.hostsys};
  sanzenvim-pkg =
    if (pkgs.stdenv.buildPlatform.isx86_64 && pkgs.stdenv.hostPlatform.isAarch64)
    then lib.optionals (inputs ? sanzenvim) sanzenvim-pkgs."${sanzenvim-prefix}Cross"
    else lib.optionals (inputs ? sanzenvim) sanzenvim-pkgs.${sanzenvim-prefix};
in {
  options.hm.programs.ides.enable = lib.mkEnableOption "IDEs and editors" // {default = true;};

  config = lib.mkMerge [
    {
      home.packages = [sanzenvim-pkg];
    }
    (lib.mkIf enabled {
      home.packages = with pkgs;
        (lib.optionals config.hm.gui.enable [
          arduino-ide
          neovide
          unityhub
        ])
        ++ [
          gcc
          clang-tools
          alejandra
          prettierd
          stylua
          black
          rustfmt
          checkstyle
          google-java-format
          cpplint
          golangci-lint
          selene
          eslint_d
          shellcheck
          ktlint
          typescript-language-server
          vue-language-server
          yaml-language-server
          vscode-langservers-extracted
          verilator
          verible
          arduino-cli
          delta
        ]
        ++ lib.optionals (inputs ? my-nur) [
          my-nur.packages.${pkgs.hostsys}.veridian
        ];

      home.sessionVariables.EDITOR = "${sanzenvim-pkg}/bin/nvim";

      xdg.configFile = lib.mkIf config.hm.gui.enable {
        "neovide/config.toml".text = lib.optionalString (inputs ? sanzenvim) ''
          fork = true
          neovim-bin = "${sanzenvim.packages.${pkgs.hostsys}.default}/bin/nvim"

          [font]
          normal = ["JetBrainsMono Nerd Font", "Noto Sans CJK JP", "Noto Color Emoji"]
          size = 12
        '';
      };
    })
  ];
}
