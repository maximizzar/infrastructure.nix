# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.nixHardened = {
    imports = [
      ./_dbus.nix
      ./_nix-daemon.nix
      ./_nix-optimise.nix
      ./_nscd.nix
    ];
  };
}
