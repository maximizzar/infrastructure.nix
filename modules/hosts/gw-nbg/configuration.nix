# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gw-nbgConfiguration = {
    imports = [
      self.nixosModules.grubBoot
      self.nixosModules.base
      self.nixosModules.inventory

      self.nixosModules.cliTooling
    ];

    services.openssh.enable = true;
    services.qemuGuest.enable = true;
  };
}
