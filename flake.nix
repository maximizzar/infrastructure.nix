# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  description = "NixOS configuration for my Homelab!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    hagezi-rpz = {
      url = "github:hagezi/dns-blocklists";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      stateVersion = "26.05";
      lib = nixpkgs.lib;
      inventory = import ./inventory;
      modules = [ ./modules ];
    in
    {

      nixosConfigurations = {
        gw-nbg = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs stateVersion inventory; };

          modules = modules ++ [
            disko.nixosModules.disko
            ./hosts/gw-nbg
          ];
        };

        gw-genesis = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs stateVersion inventory; };

          modules = modules ++ [
            disko.nixosModules.disko
            ./hosts/gw-genesis
          ];
        };

        resolver = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs stateVersion inventory; };

          modules = modules ++ [
            disko.nixosModules.disko
            ./hosts/resolver
          ];
        };

        prometheus = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs stateVersion inventory; };

          modules = modules ++ [
            disko.nixosModules.disko
            ./hosts/prometheus
          ];
        };

        #
        # Client Computers
        #

        mip3 = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs stateVersion inventory; };

          modules = modules ++ [
            disko.nixosModules.disko
            ./hosts/mip3
          ];
        };
      };

      packages.${system} = {
        gw-nbg = self.nixosConfigurations.gw-nbg.config.system.build.diskoImages;
        gw-genesis = self.nixosConfigurations.gw-genesis.config.system.build.diskoImages;
        resolver = self.nixosConfigurations.resolver.config.system.build.diskoImages;
        prometheus = self.nixosConfigurations.prometheus.config.system.build.diskoImages;
      };
    };
}
