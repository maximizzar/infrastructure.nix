# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.inventory = {
    overlay = import ./_overlay.nix;
    transit = import ./_transit.nix;
  };
}
