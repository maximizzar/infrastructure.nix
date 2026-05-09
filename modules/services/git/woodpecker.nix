# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/ns/default.nix
{ inputs, pkgs, ... }: let
    git_domain = "git.prod.maximizzar.org";
    fqdn = "woodpecker.${git_domain}";
    GITEA_URL = "forgejo.${git_domain}";

in  {
    services.woodpecker-server = {
        enable = true;
        environment = {
            WOODPECKER_HOST = "https://${fqdn}";
            WOODPECKER_OPEN = "true";
            WOODPECKER_GITEA = "true";
            WOODPECKER_GITEA_CLIENT = "";
            WOODPECKER_GITEA_URL = GITEA_URL;
        };
    };
}
