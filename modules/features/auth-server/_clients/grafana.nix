# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, ... }:
let
  cfg = config.maximizzar.authServer;
in
{
  services.authelia.instances."${cfg.domain}" = {
    settings.identity_providers.oidc = {
      clients = [
        {
          client_id = "grafana";
          client_name = "Grafana";
          claims_policy = "grafana";
          client_secret = "$pbkdf2-sha512$310000$m83jJzp4HCC476AmTyqvcw$4Ok9aPSDJFLUCRhqPKRGX7X8GxnjUf.TXqWAVejX17A6UDz.maII7rshIO4gSskT2vuy7.jT5Ul0SJLgOTcFMw";
          public = false;
          authorization_policy = "two_factor";
          require_pkce = true;
          pkce_challenge_method = "S256";
          redirect_uris = [ "https://grafana.${cfg.domain}/login/generic_oauth" ];
          scopes = [
            "openid"
            "email"
            "profile"
            "groups"
          ];

          response_types = [ "code" ];
          grant_types = [ "authorization_code" ];
          access_token_signed_response_alg = "none";
          userinfo_signed_response_alg = "none";
          token_endpoint_auth_method = "client_secret_basic";
        }
      ];

      claims_policies.grafana = {
        id_token = [
          "email"
          "name"
          "groups"
          "preferred_username"
        ];
      };
    };
  };
}
