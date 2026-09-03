# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  services.authelia.instances."maximizzar.org" = {
    settings.session.cookies = [
      {
        domain = "maximizzar.org";
        authelia_url = "https://auth.maximizzar.org";
        default_redirection_url = "https://maximizzar.org";
      }
    ];
  };
}
