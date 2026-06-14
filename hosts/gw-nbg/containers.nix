# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inventory, ... }: let
  hosts-nbg-lan = inventory.sites.nbg.router.interfaces.lan.hosts;

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

        address = [ "${hosts-nbg-lan.ns1.ip}/64" ];
        routes = [{
          Destination = "::/0";
          Gateway = hosts-nbg-lan.gw.ip;
        }];
        networkConfig.IPv6AcceptRA = false;
      };

      imports = [ ./nameserver.nix ];
      system.stateVersion = "26.05";
    };
  };

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
        nameservers = [
          "${hosts-nbg-lan.ns1.ip}"
        ];
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
}