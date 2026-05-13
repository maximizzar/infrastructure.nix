# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/users/maximizzar.nix
{ pkgs, ... }: {
    flake.nixosModules.user-maximizzar = {
        users.users.maximizzar = {
            isNormalUser = true;
            description = "admin user maximizzar";
            extraGroups = [ "wheel" ];
            hashedPassword = "$6$2OYhmSMnFVJOSJ6x$3W7pMf06csdlxU5KLzxnDpOH5iE1fNzRUy9k0EMSuEQ6.kJC2V6vCcNHvHUsosFItfotx596ZmGfKRcYDLPiD/";
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgHDCy2Ba2v4p71bY5pFr3YcYEbZi2ND9IMPrYMCgsc maximizzar@workstation"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMx9Dq1TdIjLkxme+ZcYk0Gg5O94y1zZQGbba6k1j34 maximizzar@mip3"
            ];
        };
    };
}
