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
    mkImage = import ./lib/mk-image.nix { inherit nixpkgs system; };
  in {
    # Host Configurations (for deployment)
    nixosConfigurations = {
      # LXC Configuration
      generic-lxc = mkImage [ ({ modulesPath, ... }: {
        imports = [ "${modulesPath}/virtualisation/proxmox-lxc.nix" ];
      }) ];

      # VM Configuration
      generic-vm = mkImage [ ({ modulesPath, ... }: {
        # Note: In 25.11, if qcow2.nix is missing, use qcow2-config.nix
        imports = [ "${modulesPath}/virtualisation/proxmox-image.nix" ];
      }) ];

      # Nameserver Configuration
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
        lxc-template = self.nixosConfigurations.generic-lxc.config.system.build.image;
        vm-template  = self.nixosConfigurations.generic-vm.config.system.build.image;
    };
  };
}
