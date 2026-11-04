# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  self,
  inputs,
  inventory,
  ...
}:
let
  site = "hr";
  host = inventory.overlay.sites.hr.hosts.server;
in
{
  flake.nixosConfigurations."${host.hostName}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."${host.hostName}Configuration"
    ];
  };
}
