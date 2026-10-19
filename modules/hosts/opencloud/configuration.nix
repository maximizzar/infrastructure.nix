# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.opencloudConfiguration = {
    imports = [
      self.nixosModules.qemuVm
    ];
  };
}
