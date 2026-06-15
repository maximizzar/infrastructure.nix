# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inventory, ... }: let
  hosts-nbg-lan = inventory.sites.nbg.router.interfaces.lan.hosts;

in {
  containers.proxy = {
    # Container behavior
    autoStart = true;
    restartIfChanged = true;

    # Network
    privateNetwork = true;
    hostBridge = "br-lan";

    # inject inventory
    specialArgs.inventory = inventory;

    config = { ... }: {
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      systemd.network.enable = true;
      services.resolved.enable = false;

      systemd.network.networks."10-eth0" = {
        matchConfig.Name = "eth0";

        address = [ "${hosts-nbg-lan.proxy.ip}/64" ];
        routes = [{
          Destination = "::/0";
          Gateway = hosts-nbg-lan.gw.ip;
        }];
        networkConfig.IPv6AcceptRA = false;

      };

      imports = [ ./proxy.nix ];
      system.stateVersion = "26.05";
    };
  };

  containers.static = {
    # Container behavior
    autoStart = true;
    restartIfChanged = true;

    # Network
    privateNetwork = true;
    hostBridge = "br-lan";

    # inject inventory
    specialArgs.inventory = inventory;

    bindMounts."/srv/static" = {
      hostPath = "/srv/static";
      isReadOnly = true;
    };

    config = { ... }: {
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      systemd.network.enable = true;
      services.resolved.enable = false;

      systemd.network.networks."10-eth0" = {
        matchConfig.Name = "eth0";

        address = [ "${hosts-nbg-lan.static.ip}/64" ];
        routes = [{
          Destination = "::/0";
          Gateway = hosts-nbg-lan.gw.ip;
        }];
        networkConfig.IPv6AcceptRA = false;

      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nginx = {
        enable = true;
        validateConfigFile = true;

        recommendedOptimisation = true;

        virtualHosts."static.nbg.maximizzar.org" = {
          enableACME = false;
          forceSSL = false;
          root = "/srv/static";

          locations."/music/releases/" = {
            extraConfig = ''
              autoindex on;
              autoindex_exact_size off;
              autoindex_localtime on;
            '';
          };
        };
      };
      system.stateVersion = "26.05";
    };
  };
}