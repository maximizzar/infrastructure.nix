# SPDX-FileCopyrightText: 2026 maximizzar <mail.maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  flake.deploy.nodes."${host.hostName}" = {
    hostname = "endpoint.nbg.prod.maximizzar.org";
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
