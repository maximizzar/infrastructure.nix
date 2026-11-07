# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inputs, ... }:
{
  flake.nixosModules.psysonic =
    {
      pkgs,
      ...
    }:
    {
      nix.settings = {
        substituters = [
          "https://psysonic.cachix.org"
        ];

        trusted-public-keys = [
          "psysonic.cachix.org-1:M9cQyQ7tgvUWOQ5Pyt8ozlMoPLtOZir6MfRuTH9/VYA="
        ];
      };

      environment.systemPackages = [
        inputs.psysonic.packages.${pkgs.stdenv.hostPlatform.system}.psysonic
      ];

    };
}
