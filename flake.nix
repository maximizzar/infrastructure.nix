# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# flake.nix
{
    description = "NixOS configuration for my Homelab";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

        # Disk Image Management
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Secrets-Management
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts.url = "github:hercules-ci/flake-parts";
    };

    outputs = inputs@{ flake-parts, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {
            imports = [
                ./hosts      # NixosConfigurations for each host
                ./modules    # NixosModules to use in the flake
             ];
            systems = [ "x86_64-linux" "aarch64-linux" ];
            perSystem = { config, self', inputs', pkgs, system, ... }: {
            };
        };
}
