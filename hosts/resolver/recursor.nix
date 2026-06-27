# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  inputs,
  pkgs,
  ...
}:
let
  rpz = pkgs.replaceVars ./rpz.lua {
    hagezi-rpz = "${inputs.hagezi-rpz}";
  };
in
{

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
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
