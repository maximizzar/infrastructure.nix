# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# users/maximizzar
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.users.maximizzar;

  user = "maximizzar";
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgHDCy2Ba2v4p71bY5pFr3YcYEbZi2ND9IMPrYMCgsc maximizzar@workstation"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBf+m/7QKIAIRwNP1UmUOhVhB3nQqd0ig+oXtUD4FN0L maximizzar@mip3"
  ];
in
{
  options.maximizzar.modules.users.maximizzar.enable = lib.mkEnableOption user;

  config = lib.mkIf cfg.enable {
    users.users.maximizzar = {
      isNormalUser = true;
      description = "admin user ${user}";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = ssh_keys;
    };
  };
}
