# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  program = "bandwhich";
in
{
  flake.nixosModules."${program}".programs."${program}" = {
    enable = true;
  };
}
