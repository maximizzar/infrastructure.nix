# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  description = "NixOS configuration for my Homelab!";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets-Management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    imageLib = import ./lib/mk-image.nix { inherit nixpkgs system inputs; };

  in with imageLib; {
    # Host Configurations (for deployment)
    nixosConfigurations = {

      # VM Image Configuration (QCow2)
      generic-vm = mkImage [ ({ modulesPath, ... }: {
      }) ];

      # Nameserver Configuration
      ns = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/ns/default.nix
          inputs.disko.nixosModules.disko
          sops-nix.nixosModules.sops
        ];
      };
    };

    # Map images to packages for easy building
    packages.${system} = {
        vm-template  = self.nixosConfigurations.generic-vm.config.system.build.diskoImages;
    };
  };
}
