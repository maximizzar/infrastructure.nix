# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inventory, ... }: let
  hosts = inventory.sites.genesis.router.interfaces.lan.hosts;
in {
  containers.navidrome = {
    # Container behavior
    autoStart = true;
    restartIfChanged = true;

    # Network
    privateNetwork = true;
    hostBridge = "br1";

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

        address = [ "${hosts.navidrome.ip}/64" ];
        routes = [{
          Destination = "::/0";
          Gateway = hosts.gw.ip;
        }];
        networkConfig.IPv6AcceptRA = false;
      };

      imports = [ ./services/navidrome.nix ];
      system.stateVersion = "26.05";
    };
  };

  containers.jellfin = {
    # Container behavior
    autoStart = true;
    restartIfChanged = true;

    # Network
    privateNetwork = true;
    hostBridge = "br1";

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

        address = [ "${hosts.jellyfin.ip}/64" ];
        routes = [{
          Destination = "::/0";
          Gateway = hosts.gw.ip;
        }];
        networkConfig.IPv6AcceptRA = false;
      };

      imports = [ ./services/jellyfin.nix ];
      system.stateVersion = "26.05";
    };
  };
}