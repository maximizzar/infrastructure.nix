# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  self,
  inputs,
  ...
}:
let
  host = "gw-nbg";
in
{
  flake.nixosConfigurations."${host}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."${host}Configuration"
    ];
  };

  flake.deploy.nodes."${host}" = {
    hostname = "endpoint.nbg.prod.maximizzar.org";
    user = "root";
    sshUser = "maximizzar";
    path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${host}";
  };
}
