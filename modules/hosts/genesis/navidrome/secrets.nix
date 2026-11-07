# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.navidromeSecrets =
    { config, ... }:
    {
      sops = {
        defaultSopsFile = ./secrets.yaml;
        secrets.navidrome_env = {
          sopsFile = ./secrets.yaml;
          format = "yaml";
          key = "navidrome_env";
          owner = config.services.navidrome.user;
          group = config.services.navidrome.group;
          mode = "0400";
        };

      };
    };
}
