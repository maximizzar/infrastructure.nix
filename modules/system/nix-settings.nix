# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/system/nix-settings.nix
{ ... }: let

in {
    flake.nixosModules.system-nix-settings = {
        nix = {
            enable = true;
            gc = {
                automatic = true;
                persistent = true;
                randomizedDelaySec = "1800";
            };

            optimise = {
                automatic = true;
                dates = [
                    "04:45"
                ];
                persistent = true;
                randomizedDelaySec = "1800";
            };

            settings = {
                auto-optimise-store = true;
                trusted-users = [ "root" "maximizzar" ];
            };
        };

        system.stateVersion = "25.11";
    };
}
