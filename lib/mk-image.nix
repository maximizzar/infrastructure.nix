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
            inputs.disko.nixosModules.disko
            "${inputs.self}/modules/hardware/proxmox-disk-layout.nix"
            "${inputs.self}/modules/hardware/proxmox-qemu.nix"

            "${inputs.self}/modules/services/common/networkd.nix"
            "${inputs.self}/modules/services/common/sshd.nix"
            "${inputs.self}/modules/services/common/pki.nix"
            "${inputs.self}/modules/users/default.nix"

            { system.stateVersion = "25.11"; }
        ] ++ modules;
    };
}
