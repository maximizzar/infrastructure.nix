# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ moduleWithSystem, ... }: {
  flake.nixosModules.psysonic = moduleWithSystem (
    { self', ... }: {
      nix.settings = {
        substituters = [ "https://psysonic.cachix.org" ];
        trusted-public-keys = [ "psysonic.cachix.org-1:M9cQyQ7tgvUWOQ5Pyt8ozlMoPLtOZir6MfRuTH9/VYA=" ];
      };
      environment.systemPackages = with self'.packages; [ psysonic ];
    }
  );

  perSystem = { inputs', ... }: {
    packages.psysonic = inputs'.psysonic.packages.default;
  };
}
