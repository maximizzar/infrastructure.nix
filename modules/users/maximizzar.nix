# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.users = { config, lib, ... }: {
    users.users.maximizzar = {
      enable = lib.mkDefault false;
      description = "Maximilian";
      extraGroups = [ "wheel" ] ++ lib.optional config.musnix.enable "audio";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgHDCy2Ba2v4p71bY5pFr3YcYEbZi2ND9IMPrYMCgsc maximizzar@workstation"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBf+m/7QKIAIRwNP1UmUOhVhB3nQqd0ig+oXtUD4FN0L maximizzar@mip3"
      ];
    };
  };
}
