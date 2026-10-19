# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }:
let
  host = "mip3";
in
{
  flake.nixosConfigurations."${host}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."${host}Configuration"
    ];
  };

  perSystem = { ... }: {
  };
}
