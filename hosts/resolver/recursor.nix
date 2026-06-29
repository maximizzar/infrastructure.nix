# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  pkgs,
  sources,
  ...
}:
let
  rpz = pkgs.replaceVars ./rpz.lua {
  };
in
{

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  # Install blocklists (rpz)
  environment.etc = {
    "dns-blocklists/doh.txt".source = sources.hagezi-doh.src;
    "dns-blocklists/gambling.txt".source = sources.hagezi-gambling.src;
    "dns-blocklists/hoster.txt".source = sources.hagezi-hoster.src;
    "dns-blocklists/native.amazon.txt".source = sources.hagezi-native-amazon.src;
    "dns-blocklists/native.apple.txt".source = sources.hagezi-native-apple.src;
    "dns-blocklists/native.huawei.txt".source = sources.hagezi-native-huawei.src;
    "dns-blocklists/native.lgwebos.txt".source = sources.hagezi-native-lgwebos.src;
    "dns-blocklists/native.oppo-realme.txt".source = sources.hagezi-native-oppo-realme.src;
    "dns-blocklists/native.roku.txt".source = sources.hagezi-native-roku.src;
    "dns-blocklists/native.samsung.txt".source = sources.hagezi-native-samsung.src;
    "dns-blocklists/native.tiktok.extended.txt".source = sources.hagezi-native-tiktok.src;
    "dns-blocklists/native.vivo.txt".source = sources.hagezi-native-vivo.src;
    "dns-blocklists/native.winoffice.txt".source = sources.hagezi-native-winoffice.src;
    "dns-blocklists/native.xiaomi.txt".source = sources.hagezi-native-xiaomi.src;
  };

  services.pdns-recursor = {
    enable = true;

    dns = {
      port = 53;
      allowFrom = [
        "0.0.0.0/0"
        "::/0"
      ];
    };

    dnssecValidation = "log-fail";
    exportHosts = false;
    serveRFC1918 = true;
    luaConfig = builtins.readFile rpz;

    settings = {
      recursor.forward_zones = [
        {
          zone = "maximizzar.org";
          forwarders = [
            "[fd19:38bc:a21d:1abf:52e5:75ff:fe61:13c7]:53"
          ];
        }

        {
          zone = "maximizzar.io";
          forwarders = [
            "[fd19:38bc:a21d:1abf:fcd4:d2ff:fe1d:db65]:53"
          ];
        }
      ];

      recursor.forward_zones_recurse = [
        {
          zone = ".";
          forwarders = [
            "[2620:fe::11]:853"
            "[2620:fe::fe:11]:853"
          ];
        }
      ];

      outgoing.tls_configurations = [
        {
          name = "Forward to Quad9";
          subnets = [
            "2620:fe::11/128"
            "2620:fe::fe:11/128"
          ];
          subject_name = "dns11.quad9.net";
          validate_certificate = true;
        }
      ];
      webservice = {
        webserver = true;
        address = "[::1]";
      };
    };
  };
}
