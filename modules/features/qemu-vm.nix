# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.qemuVm = { lib, ... }: {
    imports = with self.nixosModules; [
      systemdBoot
      qemuVmHardware

      base
      kernelLockdown
      nixHardened
      networkingDefault
      sshServer
      #self.nixosModules.sops

      cliTooling
      inventory
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
