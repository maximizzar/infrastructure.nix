# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  imports = [
    ./authelia
    ./forgejo
    ./forgejo-runner
    ./nameserver
    ./nginx.nix
    ./proxy
    ./resolved.nix
    ./resolver
    ./sshd.nix
  ];
}
