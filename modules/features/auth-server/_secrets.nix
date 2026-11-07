# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, ... }:
let
  cfg = config.maximizzar.authServer;
in
{
  services.authelia.instances."${cfg.domain}" = {
    settings = {
      identity_providers.oidc.jwks = [
        { key = cfg.oidcIssuerPrivateKeyFile; }
      ];
    };

    secrets = {
      manual = !cfg.enable;

      inherit (cfg)
        jwtSecretFile
        oidcHmacSecretFile
        oidcIssuerPrivateKeyFile
        sessionSecretFile
        storageEncryptionKeyFile
        ;

    };

  };

}
