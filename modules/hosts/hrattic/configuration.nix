# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inventory, ... }: {
  flake.nixosModules.hratticConfiguration =
    { pkgs, ... }:
    let
      host = inventory.overlay.sites.hr.hosts.hrattic;
    in
    {
      imports = [
        self.nixosModules.systemdBoot
        ./_hardware-configuration.nix

        self.nixosModules.kdePlasma
        self.nixosModules.cliTooling
        self.nixosModules.psysonic
      ];

      networking = {
        inherit (host) hostName domain;
        stevenblack.enable = true;
        nftables.enable = true;
        firewall = {
          enable = true;

        };

      };

      # Define User accounts
      users.users = {
        maximizzar = {
          enable = true;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };

        peter = {
          enable = true;
          extraGroups = [ "networkmanager" ];
        };

        kurt.enable = true;
      };

      environment.systemPackages = with pkgs; [
        kdePackages.kmahjongg
      ];

    };
}
