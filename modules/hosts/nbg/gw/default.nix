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
  site = "nbg";
  host = inventory.overlay.sites.nbg.hosts.gw;
in
{
  flake.nixosConfigurations."${host.hostName}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."${host.hostName}Configuration"
    ];
  };

  flake.deploy.nodes."${host.hostName}" = {
    hostname = host.Ipv6Address;
    groups = [ site ];
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

}
