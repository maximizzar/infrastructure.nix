# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/common/nix-settings.nix
{ ... }: {
  nix.settings.trusted-users = [ "root" "maximizzar" ];
}
