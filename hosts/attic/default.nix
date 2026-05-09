# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/attic/default.nix
{ inputs, pkgs, ... }: {
    imports = [
        "${inputs.self}/modules/profiles/guest.nix"
        "${inputs.self}/modules/services/attic/default.nix"
    ];

    environment.systemPackages = with pkgs; [
        inputs.attic.packages.${pkgs.system}.attic-server
    ];

    services.resolved.enable = true;
    networking.hostName = "attic";
}
