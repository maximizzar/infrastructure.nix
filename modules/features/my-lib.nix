# SPDX-FileCopyrightText: 2026 maximizzar <mail.maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.myLib =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      _module.args.myLib = import ../lib {
        inherit config lib pkgs;
      };
    };
}
