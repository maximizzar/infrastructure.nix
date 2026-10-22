# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.opencloudConfiguration =
    { config, ... }:
    let
      domain = "maximizzar.org";
      fqdn = "opencloud.services.genesis.${domain}";
    in
    {
      imports = [
        self.nixosModules.qemuVm
        self.nixosModules.webServer
      ];

      services.opencloud = {
        enable = true;
        url = "https://${fqdn}";
      };

      services.nginx.virtualHosts."${fqdn}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${config.services.opencloud.address}:${toString config.services.opencloud.port}";
        };
      };

      # Own custom Modules
      maximizzar = {
        # Enable various cli tools
        cliTooling = {
          enable = true;
        };

        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

      };

      users.users.maximizzar.enable = true;
      services.openssh.enable = true;

    };
}
