# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosModules.gw-genesisSecrets = {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      secrets = {
        "ionos-acme" = { };
      };
    };
  };
}
