{ config, ... }:
let
  fqdn = "mealie.srv.genesis.prod.maximizzar.org";
in
{
  services.mealie = {
    enable = true;
    listenAddress = "localhost";
    credentialsFile = config.sops.secrets."credentialsFile".path;
    database.createLocally = true;
  };

  services.mealie.settings = {
    # General
    BASE_URL = "https://mealie.maximizzar.org";
    TZ = "Europe/Berlin";
    ALLOW_PASSWORD_LOGIN = true;

    # OpenID Connect (OIDC)
    OIDC_AUTH_ENABLED = true;
    OIDC_SIGNUP_ENABLED = true;
    OIDC_CONFIGURATION_URL = "https://auth.maximizzar.org/.well-known/openid-configuration";
    OIDC_CLIENT_ID = "mealie";
    OIDC_AUTO_REDIRECT = true;
  };

  security.acme.certs."${fqdn}" = {
    domain = fqdn;
    webroot = "/var/lib/acme/acme-challenge";
    postRun = "systemctl reload nginx";
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."mealie" = {
    serverName = fqdn;

    sslCertificate = "/var/lib/acme/${fqdn}/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/${fqdn}/key.pem";
    sslTrustedCertificate = "/var/lib/acme/${fqdn}/chain.pem";

    forceSSL = true;
    kTLS = true;
    enableACME = true;

    quic = true;
    extraConfig = ''
      add_header Alt-Svc 'h3=":443"; ma=86400' always;
    '';

    locations."/".proxyPass = "http://localhost:9000";
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };
}
