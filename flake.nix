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

  outputs = { self, nixpkgs, disko, sops-nix, ... }@inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    baseModules = [
        ./modules/services/common/sshd.nix
        ./modules/services/common/pki.nix
        ./modules/users/default.nix
    ];

  in {
    # Host Configurations (for deployment)
    nixosConfigurations = {
      generic-guest = lib.nixosSystem {
        inherit system;
        modules = baseModules ++ [ ({modulesPath, ...}: {
          imports = [ "${modulesPath}/profiles/qcow2.nix" ];
          system.stateVersion = "25.11";
        }) ];
      };

      nameserver = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/nameserver/default.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
        ];
      };
    };

    # Map images to packages for easy building
    packages.${system} = {
        vm-image = self.nixosConfigurations.generic-guest.config.system.build.images.qcow2;
        proxmox-lxc = self.nixosConfigurations.generic-guest.config.system.build.images.proxmox-lxc;
    };
  };
}
