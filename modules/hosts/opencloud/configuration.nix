# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.opencloudConfiguration =
    { config, inventory, ... }:
    let
      host = inventory.overlay.sites.genesis.hosts.opencloud;
      fqdn = host.hostName + "." + host.domain;
    in
    {
      imports = [
        self.nixosModules.qemuVm
        self.nixosModules.webServer
      ];

      services.opencloud = {
        enable = true;
        url = "https://${fqdn}";
        environment = {
          PROXY_TLS = "false"; # disable https when behind reverse-proxy
        };
      };

      services.nginx.virtualHosts."${fqdn}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${config.services.opencloud.address}:${toString config.services.opencloud.port}";
          proxyWebsockets = false;
        };
      };

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;

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

        networking.default.MACAddress = host.MACAddress;
      };

      users.users.maximizzar.enable = true;

    };
}
