# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/networking
{
  imports = [
    ./container-networking.nix
    ./ip-forwarding.nix
    ./vm-networking.nix
  ];
}
