# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# lib/mk-image.nix
{ nixpkgs, system, inputs, ... }: let
    lib = nixpkgs.lib;
in {
    mkImage = modules: lib.nixosSystem {
        inherit system;
        modules = [
            # Hardware
            inputs.disko.nixosModules.disko
            "${inputs.self}/modules/hardware/proxmox-disk-layout.nix"
            "${inputs.self}/modules/hardware/proxmox-qemu.nix"

            # Common Modules
            "${inputs.self}/modules/services/common/nix-settings.nix"
            "${inputs.self}/modules/services/common/networkd.nix"
            "${inputs.self}/modules/services/common/sshd.nix"
            "${inputs.self}/modules/services/common/pki.nix"

            # User Settings
            "${inputs.self}/modules/users/default.nix"
        ] ++ modules;
    };
}
