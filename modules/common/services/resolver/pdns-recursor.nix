# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  ...
}:
let
  cfg = config.maximizzar.modules.services.resolver;
in
{
  services.pdns-recursor = {
    enable = cfg.enable;
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
      forward_zones = cfg.forward_zones;
      forward_zones_recurse = [
        {
          zone = ".";
          forwarders = [
            "[2620:fe::11]:853"
            "[2620:fe::fe:11]:853"
          ];
        }
      ];
    };

    settings.outgoing.tls_configurations = [
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

  };
}
