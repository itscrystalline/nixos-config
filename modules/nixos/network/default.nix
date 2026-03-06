{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption;
  inherit (config.secrets) known-networks;

  mkProfiles = list:
    builtins.listToAttrs (map (profile: (
        if (builtins.isString profile && (known-networks ? ${profile}))
        then {
          name = profile;
          value = known-networks.${profile};
        }
        else if (builtins.isAttrs profile && (profile.connection ? id))
        then {
          name = profile.connection.id;
          value = profile;
        }
        else builtins.throw "`profile` is not a well-known network profile name described in `config.secrets.known-networks`, or an attribute set describing one, containing the attribute `connection.id`."
      ))
      list);
in {
  imports = [./network-mounts.nix];

  options.network = {
    dhcp = mkEnableOption "DHCP" // {default = true;};
    trustedInterfaces = mkOption {
      type = types.listOf types.str;
      description = "Trusted Network Interfaces.";
      default = [];
    };
    ports = {
      tcp = mkOption {
        type = types.listOf types.port;
        description = "TCP ports to open.";
        default = [];
      };
      tcpRange = mkOption {
        type = types.listOf (types.attrsOf types.port);
        description = "TCP port ranges to open.";
        default = [];
      };
      udp = mkOption {
        type = types.listOf types.port;
        description = "UDP ports to open.";
        default = [];
      };
      udpRange = mkOption {
        type = types.listOf (types.attrsOf types.port);
        description = "UDP port ranges to open.";
        default = [];
      };
    };
    profiles = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      description = "NetworkManager profiles automatically configured via known-networks or inline attrsets.";
      default = [];
    };
    profileEnvSecret = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Name of the sops secret whose value is a shell environment file
        (KEY=value lines). Variables from this file are substituted into
        profile fields that reference them using $VAR syntax via
        networking.networkmanager.ensureProfiles.environmentFiles.
        Profile structure (SSID, IP config, etc.) stays in git-crypt
        known-networks; only credentials live in sops.

        Three authentication types are supported:

        Open networks — no credentials needed; no variables required.
        Profile in known-networks has no wifi-security section.

        WPA-PSK — add a PSK variable and reference it in the profile:
          env file:   santhad_PSK=my-passphrase
          known-networks: wifi-security.psk = "$santhad_PSK"

        WPA-EAP / PEAP / MSCHAPv2 — add identity + password variables:
          env file:   KMITL_HiSpeed_IDENTITY=username
                      KMITL_HiSpeed_PASSWORD=password
          known-networks:
            802-1x.identity        = "$KMITL_HiSpeed_IDENTITY"
            802-1x.password        = "$KMITL_HiSpeed_PASSWORD"
            802-1x.eap             = "peap"
            802-1x.phase2-auth     = "mschapv2"
            wifi-security.key-mgmt = "wpa-eap"
      '';
    };
  };
  config = {
    users.users.${config.core.primaryUser}.extraGroups = ["networkmanager"];

    # Declare the env-file sops secret when profileEnvSecret is configured.
    sops.secrets = lib.optionalAttrs (config.network.profileEnvSecret != null) {
      ${config.network.profileEnvSecret} = {};
    };

    networking = {
      networkmanager.enable = true;
      networkmanager.ensureProfiles = {
        profiles = mkProfiles config.network.profiles;
        # Wire the sops-managed env file so that $VAR placeholders in profiles
        # (e.g. psk = "$SANTHAD_PSK") are substituted at activation.
        environmentFiles =
          if config.network.profileEnvSecret != null
          then [config.sops.secrets.${config.network.profileEnvSecret}.path]
          else [];
      };
      hostName = config.core.name;
      useDHCP = lib.mkDefault config.network.dhcp;
      firewall = with config.network.ports; {
        enable = true;
        inherit (config.network) trustedInterfaces;
        allowedTCPPorts = tcp;
        allowedUDPPorts = udp;
        allowedTCPPortRanges = tcpRange;
        allowedUDPPortRanges = udpRange;
      };
    };
  };
}
