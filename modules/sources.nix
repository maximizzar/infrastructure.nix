# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.sources = { pkgs, ... }: {
    _module.args.sources = pkgs.callPackage ../_sources/generated.nix { };
  };
}
