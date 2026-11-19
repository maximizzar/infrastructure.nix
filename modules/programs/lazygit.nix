# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.lazygit = {
    programs.lazygit = {
      enable = true;
      settings = { };
    };
  };
}
