{lib, ...}: let
  applyDefaults = config:
    {
      realName = config.name;
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
      host = "mail.iw2tryhard.dev";
      port = 993;
    };
    smtp = {
      host = "mail.iw2tryhard.dev";
      port = 465;
    };
  };
in {
  accounts.email.accounts = lib.mapAttrs (_: applyDefaults) {
    main =
      {
        name = "Thad Choyrum";
        address = "real@iw2tryhard.dev";
        primary = true;
      }
      // mailServerDefaults;

    crystal =
      {
        name = "Crystal";
        address = "crystal@iw2tryhard.dev";
        aliases = ["tryhard@iw2tryhard.dev" "colonthree@iw2tryhard.dev"];
      }
      // mailServerDefaults;

    main_gmail = {
      address = "real.thad.choyrum@gmail.com";
      realName = "Thad Choyrum";
      flavor = "gmail.com";
    };
    other_gmail = {
      address = "pvpthadgaming@gmail.com";
      realName = "itscrystalline";
      flavor = "gmail.com";
    };
    recovery = {
      address = "choyrumthad@gmail.com";
      realName = "itscrystalline";
      flavor = "gmail.com";
    };
  };
}
