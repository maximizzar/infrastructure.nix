# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.bash =
    let
      modules = with self.nixosModules; [
        starship
      ];
    in
    {
      imports = modules;
      programs.bash = {
        enable = true;
        blesh.enable = true;
      };
    };
}
