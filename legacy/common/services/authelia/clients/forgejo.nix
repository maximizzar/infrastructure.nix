# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  services.authelia.instances."maximizzar.org" = {
    settings.identity_providers.oidc.clients = [
      {
        client_id = "forgejo";
        client_name = "Forgejo";
        client_secret = "$pbkdf2-sha512$310000$oLU.5XtOWA3JbCprsCKUfA$najVGnbOOcjM/DSf/9DnwMg7L1CC5jLjlZFLpQl7jcXhKWLi1xhU94JpnhuOA/cmdY/kfjQIxdwWhh02FCcWGg";
        public = false;
        authorization_policy = "two_factor";
        require_pkce = true;
        pkce_challenge_method = "S256";
        redirect_uris = [ "https://forgejo.maximizzar.org/user/oauth2/authelia/callback" ];
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
  };
}
