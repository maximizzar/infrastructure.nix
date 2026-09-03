# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  services.authelia.instances."maximizzar.org" = {
    settings.access_control = {
      default_policy = "deny";
      rules = [
        {
          domain = "auth.maximizzar.org";
          policy = "bypass";
        }
      ];
    };
  };
}
