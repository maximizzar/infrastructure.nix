# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.monitoringSecrets = {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      secrets =
        let
          owner = "grafana";
          group = "root";
          mode = "0660";
        in
        {
          "grafana/database/password" = {
            inherit owner group mode;
          };

          "grafana/security/secret_key" = {
            inherit owner group mode;
          };

          "grafana/auth/generic_oauth/client_secret" = {
            inherit owner group mode;
          };
        };

    };
  };
}
