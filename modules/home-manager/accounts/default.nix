{lib, ...}: let
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
  # mailServerDefaults = {
  #   imap = {
  #     host = "mail.iw2tryhard.dev";
  #     port = 993;
  #   };
  #   smtp = {
  #     host = "mail.iw2tryhard.dev";
  #     port = 465;
  #   };
  # };
in {
  accounts.email.accounts = lib.mapAttrs (_: applyDefaults) {
    # main =
    #   {
    #     realName = "Thad Choyrum";
    #     address = "real@iw2tryhard.dev";
    #     primary = true;
    #   }
    #   // mailServerDefaults;
    #
    # crystal =
    #   {
    #     realName = "Crystal";
    #     address = "crystal@iw2tryhard.dev";
    #     aliases = ["tryhard@iw2tryhard.dev" "colonthree@iw2tryhard.dev"];
    #   }
    #   // mailServerDefaults;

    "Main" = {
      address = "real.thad.choyrum@gmail.com";
      realName = "Thad Choyrum";
      aliases = ["real@iw2tryhard.dev"];
      flavor = "gmail.com";
      primary = true;
    };
    "Crystal" = {
      address = "pvpthadgaming@gmail.com";
      realName = "itscrystalline";
      aliases = ["crystal@iw2tryhard.dev" "tryhard@iw2tryhard.dev" "colonthree@iw2tryhard.dev"];
      flavor = "gmail.com";
    };
    "Other Email" = {
      address = "choyrumthad@gmail.com";
      realName = "itscrystalline";
      flavor = "gmail.com";
    };
  };
}
