# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  inventory = {
    overlay = import ./_overlay.nix;
    transit = import ./_transit.nix;
  };
in
{
  # flake-parts
  _module.args.inventory = inventory;

  # NixOS
  flake.nixosModules.inventory = { ... }: {
    _module.args.inventory = inventory;
  };
}
