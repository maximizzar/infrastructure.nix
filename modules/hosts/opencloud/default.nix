# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  self,
  inputs,
  deploy-rs,
  ...
}:
let
  host = "opencloud";
in
{
  flake.nixosConfigurations."${host}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."${host}Configuration"
    ];
  };

  flake.deploy.nodes."${host}" = {
    hostname = "fe80::1";
    profiles.system = {
      user = "root";
      sshUser = "maximizzar";
      path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${host}";
    };
  };

  perSystem = {
    packages."${host}-image" = self.nixosConfigurations.${host}.config.system.build.diskoImages;
  };
}
