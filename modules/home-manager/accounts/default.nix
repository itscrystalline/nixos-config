{
  lib,
  config,
  ...
}: let
  applyDefaults = config:
    {
      userName = config.address;

      thunderbird = {
        enable = true;
        settings = id: {
          "mail.identity.id_${id}.reply_on_top" = 1;
          "mail.identity.id_${id}.sig_bottom" = false;
          # Sorting
          "mailnews.default_sort_order" = 2; # descending
          "mailnews.default_sort_type" = 18; # by date
          # Disable telemetry
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.prompted" = 2;
        };
      };
    }
    // config;
  mailServerDefaults = {
    imap = {
      host = "mx1.iw2tryhard.dev";
      port = 993;
    };
    smtp = {
      host = "mx1.iw2tryhard.dev";
      port = 465;
    };
  };
in {
  accounts.email.accounts = lib.mapAttrs (_: applyDefaults) {
    "Main" =
      {
        realName = "Thad Choyrum";
        address = "real@iw2tryhard.dev";
        primary = true;
      }
      // mailServerDefaults;

    "Crystal" =
      {
        realName = "Crystal";
        address = "crystal@iw2tryhard.dev";
        aliases = ["tryhard@iw2tryhard.dev" "colonthree@iw2tryhard.dev"];
      }
      // mailServerDefaults;

    "Main (Gmail)" = {
      address = "real.thad.choyrum@gmail.com";
      realName = "Thad Choyrum";
      flavor = "gmail.com";
    };
    "Crystal (Gmail)" = {
      address = "pvpthadgaming@gmail.com";
      realName = "Crystal";
      flavor = "gmail.com";
    };
    "School" = {
      address = "66991035@kmitl.ac.th";
      realName = "Thad Choyrum";
      flavor = "gmail.com";
    };
    "Other Email" = {
      address = "choyrumthad@gmail.com";
      realName = "itscrystalline";
      flavor = "gmail.com";
    };
  };
  xdg.configFile = lib.mkIf config.hm.programs.cli.enable {
    "matcha/config.json".text = builtins.toJSON {
      accounts = map ({
        name,
        value,
      }:
        {
          id = lib.strings.sanitizeDerivationName name;
          name = value.realName;
          email = value.address;
          fetch_email = value.address;
          service_provider =
            if value.flavor == "gmail.com"
            then "gmail"
            else "custom";
        }
        // lib.optionalAttrs (value.flavor == "custom") {
          imap_server = value.imap.host;
          imap_port = value.imap.port;
          smtp_server = value.smtp.host;
          smtp_port = value.smtp.port;
        }) (lib.attrsToList config.accounts.email.accounts);
      theme = "Rose";
      enable_split_pane = true;
      enable_detailed_dates = true;
      date_format = "DD/MM/YYYY HH:MM";
      disable_images = false;
      hide_tips = false;
      disable_spellcheck = false;
      disable_spell_suggestions = false;
      body_cache_threshold_mb = 100;
    };
  };
}
