# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gw-nbgConfiguration = { config, ... }: {
    imports = [
      self.nixosModules.grubBoot
      ./_hardware-configuration.nix

      self.nixosModules.cliTooling
    ];

    services.openssh.enable = true;
    services.qemuGuest.enable = true;
  };
}
