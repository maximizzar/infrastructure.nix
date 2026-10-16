# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosConfigurations.mip3 = { pkgs, lib, ... }: {
    modules = [
      self.nixosModules.mip3Configuration
    ];
  };
}
