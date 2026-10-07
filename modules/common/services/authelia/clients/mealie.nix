# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  services.authelia.instances."maximizzar.org" = {
    settings.identity_providers.oidc.clients = [
      {
        client_id = "mealie";
        client_name = "Mealie";
        client_secret = "$pbkdf2-sha512$310000$xDiA5h87Fzio330XXkcaAw$6oZDGgxQEUdVJG/y.aJ0CV6n65EmisI9iP6TT/3urFeG3ccgxaGi0Jnwee6Jy47tEAibpB425aZ0EQyFtFylIA";
        public = false;
        authorization_policy = "two_factor";
        require_pkce = true;
        pkce_challenge_method = "S256";
        redirect_uris = [ "https://mealie.maximizzar.org/login" ];
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
