# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/ns/default.nix
{ inputs, pkgs, ... }: {
    imports = [
        "${inputs.self}/modules/profiles/guest.nix"
        "${inputs.self}/modules/services/powerdns/default.nix"
    ];

    environment.systemPackages = with pkgs; [
        dig
    ];

    services.resolved.enable = false;
    networking.hostName = "ns";
}
