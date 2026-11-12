{ config, ... }: {
  getSecretPath = secret: config.sops.secrets."${secret}".path;

  getCertHTTP01 = domain: {
    "${domain}" = {
      inherit domain;
      webroot = "/var/lib/acme/acme-challenge";
    };
  };

  mkNginxVhost = { fqdn, proxyPass }: {
    "${fqdn}" = {
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

      locations."/".proxyPass = proxyPass;
    };
  };
}
