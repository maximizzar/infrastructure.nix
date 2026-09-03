# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "forgejo_admin/name" = { };
      "forgejo_admin/password" = { };

      "forgejo_database/password" = { };
    };
  };
}
