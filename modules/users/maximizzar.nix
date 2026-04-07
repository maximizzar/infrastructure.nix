# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/users/maximizzar.nix
{ pkgs, ... }: {
  users.users.maximizzar = {
    isNormalUser = true;
    description = "admin user maximizzar";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgHDCy2Ba2v4p71bY5pFr3YcYEbZi2ND9IMPrYMCgsc maximizzar@workstation"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMx9Dq1TdIjLkxme+ZcYk0Gg5O94y1zZQGbba6k1j34 maximizzar@mip3"
    ];
  };
}
