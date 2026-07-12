{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) boinc;
  enabled = boinc.enable;
  guiEnabled = config.gui.enable;

  boinc' =
    if guiEnabled
    then pkgs.boinc
    else pkgs.boinc-headless;
in {
  options.crystals-services.boinc = {
    enable = lib.mkEnableOption "BOINC project computing";
    projects = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          url = lib.mkOption {
            type = lib.types.str;
            description = "The project's URL. Ends with a `/`.";
            default = "";
          };
          key = lib.mkOption {
            type = lib.types.str;
            description = "The account weak key secret name that is associated with this project. prepended by `boinc_` and appended by `_key`.";
            default = "";
          };
        };
      });
      description = "List of BOINC projects to join.";
      default = [];
    };
  };
  config = lib.mkIf enabled {
    sops.secrets = lib.listToAttrs (map (p: {
        name = "boinc_${p.key}_key";
        value = {
          owner = "boinc";
          group = "boinc";
        };
      })
      boinc.projects);

    services.boinc = {
      enable = true;
      package = boinc';
    };

    systemd.services.join-boinc-projects = let
      passwd = "${config.services.boinc.dataDir}/gui_rpc_auth.cfg";
      sopsPath = key: config.sops.secrets."boinc_${key}_key".path;
    in {
      description = "Declaritively join BOINC projects.";
      after = ["boinc.service"];
      requires = ["boinc.service"];
      wantedBy = ["boinc.service"];
      path = with pkgs; [ripgrep coreutils boinc'];
      script = ''
        until test -e "${passwd}"; do sleep 1; done

        declare -A url_key
        ${lib.concatLines (map (p: ''url_key["${p.url}"]="$(cat "${sopsPath p.key}")"'') boinc.projects)}

        mapfile -t joined < <(boinccmd --passwd "$(cat "${passwd}")" --get_project_status | rg "master URL" | cut -c16- | sort)
        readarray -t declared < <(printf '%s\n' ${lib.concatStringsSep " " (map (p: ''"${p.url}"'') boinc.projects)} | sort)

        mapfile -t declared_but_not_joined < <(rg -vxFf <(printf '%s\n' "''${joined[@]}") <(printf '%s\n' "''${declared[@]}"))
        mapfile -t joined_but_not_declared < <(rg -vxFf <(printf '%s\n' "''${declared[@]}") <(printf '%s\n' "''${joined[@]}"))

        for project in "''${declared_but_not_joined[@]}"; do
          boinccmd --passwd "$(cat "${passwd}")" --project_attach "$project" "''${url_key["$project"]}"
          echo "Joined $project"
        done
        for project in "''${joined_but_not_declared[@]}"; do
          boinccmd --passwd "$(cat "${passwd}")" --project "$project" detach
          echo "Left $project"
        done
      '';
      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "journal";
        StandardError = "journal";
        User = "boinc";
        Group = "boinc";
      };
    };
    users.users.${config.core.primaryUser}.extraGroups = ["boinc"];
  };
}
