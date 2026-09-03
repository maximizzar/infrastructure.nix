# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  # OS contains code only for nixos
  imports = [
    ./hardware
    ./profiles
    ./security
    ./services
  ];
}
