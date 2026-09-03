# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "NixOS configuration for my Homelab!";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-facter-modules,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = nixpkgs.lib;
      inventory = import ./inventory;
      sources = nixpkgs.legacyPackages.${system}.callPackage ./_sources/generated.nix { };
      modules = [
        ./modules/default-os.nix
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
      ];

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
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/gw-nbg ];
        };

        gw-genesis = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/gw-genesis ];
        };

        resolver = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              inventory
              sources
              ;
          };
          modules = modules ++ [ ./hosts/resolver ];
        };

        prometheus = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/prometheus ];
        };

        forgejo = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/forgejo ];
        };

        runner = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/runner ];
        };

        vaultwarden = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/vaultwarden ];
        };

        auth = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/auth ];
        };

        #
        # Client Computers
        #

        mip3 = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs inventory; };
          modules = modules ++ [ ./hosts/mip3 ];
        };

        hrattic = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = modules ++ [ ./hosts/hrattic ];
        };

      };

      packages.${system} = {
        default = self.packages.${system}.release;
        release = release-script;

        gw-nbg = self.nixosConfigurations.gw-nbg.config.system.build.diskoImages;

        gw-genesis = self.nixosConfigurations.gw-genesis.config.system.build.diskoImages;
        resolver = self.nixosConfigurations.resolver.config.system.build.diskoImages;
        prometheus = self.nixosConfigurations.prometheus.config.system.build.diskoImages;
        forgejo = self.nixosConfigurations.forgejo.config.system.build.diskoImages;
        runner = self.nixosConfigurations.runner.config.system.build.diskoImages;
        vaultwarden = self.nixosConfigurations.vaultwarden.config.system.build.diskoImages;
        auth = self.nixosConfigurations.auth.config.system.build.diskoImages;
      };

      apps.${system} = {
        release = {
          type = "app";
          program = "${self.packages.${system}.release}/bin/release";
        };
      };
    };
}
