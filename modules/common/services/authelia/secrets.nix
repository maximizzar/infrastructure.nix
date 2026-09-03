# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, ... }:
let
  cfg = config.maximizzar.modules.services.authelia;
in
{
  services.authelia.instances."maximizzar.org" = {
    settings = {
      identity_providers.oidc.jwks = [
        { key = cfg.oidcIssuerPrivateKeyFile; }
      ];
    };

    secrets = {
      manual = !cfg.enable;

      jwtSecretFile = cfg.jwtSecretFile;
      oidcHmacSecretFile = cfg.oidcHmacSecretFile;
      oidcIssuerPrivateKeyFile = cfg.oidcIssuerPrivateKeyFile;
      sessionSecretFile = cfg.sessionSecretFile;
      storageEncryptionKeyFile = cfg.storageEncryptionKeyFile;
    };

  };

}
