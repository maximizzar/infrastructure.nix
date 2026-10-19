# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.qemuVm = {
    imports = [
      self.nixosModules.systemdBoot
      self.nixosModules.qemuVmHardware

      self.nixosModules.base
      self.nixosModules.sshServer
      #self.nixosModules.sops

      self.nixosModules.cliTooling
    ];

    maximizzar.cliTooling.enable = true;
  };
}
