# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosModules.gw-nbgSecrets = {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      secrets = {
        "ionos-acme" = { };
        "wg/private_key" = { };
      };
    };
  };
}
