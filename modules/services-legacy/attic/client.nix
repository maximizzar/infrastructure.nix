# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/attic/client.nix
{
    nix.settings = {
        substituters = [
            "https://attic.core.prod.maximizzar.org/prod"
            "https://cache.nixos.org"
        ];

        trusted-public-keys = [
            "prod:2KChCdAvT07loXw41UO8KA+5YI8OkI7kKnqKzX3R7bE="
        ];
    };
}
