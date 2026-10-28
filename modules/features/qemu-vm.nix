# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.qemuVm = { lib, ... }: {
    imports = [
      self.nixosModules.systemdBoot
      self.nixosModules.qemuVmHardware

      self.nixosModules.base
      self.nixosModules.networkingDefault
      self.nixosModules.sshServer
      #self.nixosModules.sops

      self.nixosModules.cliTooling
      self.nixosModules.inventory
    ];

    maximizzar = {
      cliTooling.enable = true;
      networking.default.enable = lib.mkDefault true;
    };

    users.users.maximizzar.enable = true;
    security.sudo.wheelNeedsPassword = false;

    services = {
      qemuGuest.enable = true;
    };
  };
}
