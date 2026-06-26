# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ ... }: {
  imports = [
    ./acme.nix
    ./locale-de.nix
    ./nix.nix
  ];
}
