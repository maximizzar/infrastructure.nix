# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.base =
    let
      modules = with self.nixosModules; [
        inventory
        sources

        nixSettings
        myLib
      ];
    in
    {
      imports = modules;
    };
}
