# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inventory, ... }: let
  hosts = inventory.sites.nbg.router.interfaces.genesis.hosts;
in {
  containers.ns1 = {
    # Container behavior
    autoStart = true;
    restartIfChanged = true;

    # Network
    privateNetwork = true;
    hostBridge = "br-lan";

    # inject inventory
    specialArgs.inventory = inventory;

    config = { ... }: {
      networking.useDHCP = false;
      networking.useNetworkd = true;

      systemd.network.enable = true;
      services.resolved.enable = false;

      systemd.network.networks."10-eth0" = {
        matchConfig.Name = "eth0";

        address = [ "${hosts.ns1.ip}/64" ];
        routes = [{
          Destination = "::/0";
          Gateway = hosts.gw.ip;
        }];
        networkConfig.IPv6AcceptRA = false;
      };

      imports = [ ./nameserver.nix ];
      system.stateVersion = "26.05";
    };
  };
}