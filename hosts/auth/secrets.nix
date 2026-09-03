# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  autheliaUser = "authelia-maximizzar.org";
in
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "authelia/jwtSecret" = {
        owner = autheliaUser;
      };

      "authelia/oidcHmacSecret" = {
        owner = autheliaUser;
      };

      "authelia/oidcIssuerPrivateKey" = {
        owner = autheliaUser;
      };

      "authelia/sessionSecret" = {
        owner = autheliaUser;
      };

      "authelia/storageEncryptionKey" = {
        owner = autheliaUser;
      };

      "authelia/usersDatabase" = {
        owner = autheliaUser;
      };

    };
  };
}
