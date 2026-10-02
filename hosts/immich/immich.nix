# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ pkgsUnstable, ... }:
let
  fqdn = "immich.srv.genesis.prod.maximizzar.org";
in
{
  services.immich = {
    enable = true;
    package = pkgsUnstable.immich;
  };

  security.acme.certs."${fqdn}" = {
    domain = fqdn;
    webroot = "/var/lib/acme/acme-challenge";
    postRun = "systemctl reload nginx";
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."immich" = {
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

    locations."/".proxyPass = "http://localhost:2283";
  };
}
