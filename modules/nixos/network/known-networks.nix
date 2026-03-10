{
  KMITL-HiSpeed = {
    "802-1x" = {
      eap = "peap;";
      identity = "$KMITL_HiSpeed_IDENTITY";
      password = "$KMITL_HiSpeed_PASSWORD";
      phase2-auth = "mschapv2";
    };
    connection = {
      id = "KMITL-HiSpeed";
      interface-name = "wlp4s0";
      timestamp = "1771050100";
      type = "wifi";
      uuid = "cff8983f-7384-42fa-b6a2-bd532f8b6bf5";
    };
    ipv4.method = "auto";
    ipv6.addr-gen-mode = "default";
    ipv6.method = "auto";
    wifi = {
      mode = "infrastructure";
      ssid = "KMITL-HiSpeed";
    };
    wifi-security.key-mgmt = "wpa-eap";
  };
  KMITL-WIFI = {
    connection = {
      id = "KMITL-WIFI";
      interface-name = "wlp4s0";
      type = "wifi";
      uuid = "323e6173-0846-4045-a973-35254fd3ea9a";
    };
    ipv4 = {method = "auto";};
    ipv6 = {
      addr-gen-mode = "default";
      method = "auto";
    };
    wifi = {
      mode = "infrastructure";
      ssid = "KMITL-WIFI";
    };
  };
  "cwystaw the neko :3 ^w^" = {
    connection = {
      id = "cwystaw the neko :3 ^w^";
      interface-name = "wlp4s0";
      type = "wifi";
      uuid = "d6c4a10a-0466-43f7-b5c9-615801f36d6f";
    };
    ipv4 = {method = "auto";};
    ipv6 = {
      addr-gen-mode = "default";
      method = "auto";
    };
    wifi = {
      mode = "infrastructure";
      ssid = "cwystaw the neko :3 ^w^";
    };
    wifi-security = {
      auth-alg = "open";
      key-mgmt = "wpa-psk";
      psk = "$cwystaw_the_neko_PSK";
    };
  };
  dormpi = {
    connection = {
      id = "dormpi";
      interface-name = "wlp4s0";
      type = "wifi";
      uuid = "3484b778-9d92-48bc-8e0c-2f48006c3f27";
    };
    ipv4 = {method = "auto";};
    ipv6 = {
      addr-gen-mode = "default";
      method = "auto";
    };
    wifi = {
      mode = "infrastructure";
      ssid = "dormpi";
    };
    wifi-security = {
      auth-alg = "open";
      key-mgmt = "wpa-psk";
      psk = "$dormpi_PSK";
    };
  };
  santhad = {
    connection = {
      id = "santhad";
      interface-name = "wlp4s0";
      type = "wifi";
      uuid = "9b762282-50f5-48de-a7fa-c56cd949a459";
    };
    ipv4 = {method = "auto";};
    ipv6 = {
      addr-gen-mode = "default";
      method = "auto";
    };
    proxy = {};
    wifi = {
      mode = "infrastructure";
      ssid = "santhad";
    };
    wifi-security = {
      auth-alg = "open";
      key-mgmt = "wpa-psk";
      psk = "$santhad_5G_PSK";
    };
  };
  santhad_5G = {
    connection = {
      id = "santhad_5G";
      interface-name = "wlp4s0";
      type = "wifi";
      uuid = "588088d7-3561-4862-a004-b46acd13acde";
    };
    ipv4 = {method = "auto";};
    ipv6 = {
      addr-gen-mode = "default";
      method = "auto";
    };
    proxy = {};
    wifi = {
      mode = "infrastructure";
      ssid = "santhad_5G";
    };
    wifi-security = {
      auth-alg = "open";
      key-mgmt = "wpa-psk";
      psk = "$santhad_PSK";
    };
  };
}
