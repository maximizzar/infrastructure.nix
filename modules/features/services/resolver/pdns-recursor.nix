# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.resolver =
    { config, ... }:
    let
      cfg = config.maximizzar.resolver;
      quad9 = {
        primary = "2620:fe::11";
        secondary = "2620:fe::fe:11";
        domain = "dns11.quad9.net";
      };
    in
    {
      services.pdns-recursor = {
        inherit (cfg) enable;
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

        settings.recursor = {
          inherit (cfg) forward_zones;
          forward_zones_recurse = [
            {
              zone = ".";
              forwarders = [
                "[${quad9.primary}]:853"
                "[${quad9.secondary}]:853"
              ];
            }
          ];
        };

        settings.outgoing.tls_configurations = [
          {
            name = "Forward to Quad9";
            subnets = [
              "${quad9.primary}/128"
              "${quad9.secondary}/128"
            ];
            subject_name = quad9.domain;
            validate_certificate = true;
          }
        ];

      };
    };
}
