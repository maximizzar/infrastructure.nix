# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inventory, ... }: {
  flake.nixosModules.hrserverConfiguration =
    { pkgs, ... }:
    let
      host = inventory.overlay.sites.hr.hosts.server;
    in
    {
      imports = with self.nixosModules; [
        hrserverHardware

        base
        kernelLockdown
        nixHardened
        networkingDefault
        sshServer
        sops

        cliTooling
      ];

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;
        };
      };

      users.users.maximizzar.enable = true;
      security.sudo.wheelNeedsPassword = false;

      # Own custom Modules
      maximizzar = {
        # Enable various cli tools
        cliTooling = {
          enable = true;
          dev = true;
          sys = true;
        };

        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

        networking.default = {
          enable = true;
          Interface = "enp1s0";
          MACAddress = host.MACAddress;
        };

      };

      # List packages installed in system profile.
      environment.systemPackages = with pkgs; [
        dnsutils
        dig
        git
      ];

    };
}
