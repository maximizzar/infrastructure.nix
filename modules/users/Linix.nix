# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.base = { lib, ... }: {
    users.users.Linix = {
      enable = lib.mkDefault false;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
    };
  };
}
