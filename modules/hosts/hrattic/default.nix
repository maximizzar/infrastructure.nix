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
  host = inventory.overlay.sites.genesis.hosts.hrattic;
in
{
  flake.nixosConfigurations."${host.hostName}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."${host.hostName}Configuration"
    ];
  };

  flake.deploy.nodes."${host.hostName}" = {
    hostname = host.Ipv6Address;
    profiles.system = {
      user = "root";
      sshUser = "maximizzar";
      path =
        inputs.deploy-rs.lib.${
          self.nixosConfigurations."${host.hostName}".pkgs.stdenv.hostPlatform.system
        }.activate.nixos
          self.nixosConfigurations."${host.hostName}";
    };
  };

  perSystem = {
    #packages."${host}-image" = self.nixosConfigurations.${host}.config.system.build.diskoImages;
  };
}
