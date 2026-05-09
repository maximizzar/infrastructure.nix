# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/git/forgejo.nix
{ inputs, pkgs, ... }: {
    imports = [
        "${inputs.self}/modules/profiles/guest.nix"
        "${inputs.self}/modules/services/git/forgejo.nix"
    ];

    environment.systemPackages = with pkgs; [
        xh
    ];

    services.resolved.enable = true;
    networking.hostName = "forgejo";
}
