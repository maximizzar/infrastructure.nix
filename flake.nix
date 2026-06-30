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
      pkgs = import nixpkgs { inherit system; };
      stateVersion = "26.05";
      lib = nixpkgs.lib;
      inventory = import ./inventory;
      sources = nixpkgs.legacyPackages.${system}.callPackage ./_sources/generated.nix { };
      modules = [ ./modules ];

      release-script = pkgs.writeShellApplication {
        name = "release";
        runtimeInputs = [
          pkgs.goreleaser
          pkgs.git
          pkgs.bash
        ];
        text = builtins.readFile ./scripts/release.sh;
      };
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
          specialArgs = {
            inherit
              inputs
              stateVersion
              inventory
              sources
              ;
          };

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

        runner = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs stateVersion inventory; };

          modules = modules ++ [
            disko.nixosModules.disko
            ./hosts/runner
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
        default = self.packages.${system}.release;
        release = release-script;

        gw-nbg = self.nixosConfigurations.gw-nbg.config.system.build.diskoImages;
        gw-genesis = self.nixosConfigurations.gw-genesis.config.system.build.diskoImages;
        resolver = self.nixosConfigurations.resolver.config.system.build.diskoImages;
        prometheus = self.nixosConfigurations.prometheus.config.system.build.diskoImages;
        runner = self.nixosConfigurations.runner.config.system.build.diskoImages;
      };

      apps.${system} = {
        release = {
          type = "app";
          program = "${self.packages.${system}.release}/bin/release";
        };
      };
    };
}
