# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inventory, ... }: let
  #TODO: Generalize more and move hosts out of context!
  hosts = inventory.sites.genesis.router.interfaces.lan.hosts;
  fqdn = hosts.static.fqdn;
  acme_path = "/var/lib/acme/${fqdn}";
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];
  services.nginx = {
    enable = true;
    validateConfigFile = true;

    recommendedOptimisation = true;

    virtualHosts."${fqdn}" = {
      enableACME = true;
      forceSSL = true;

      sslCertificate =  "${acme_path}/fullchain.pem";
      sslCertificateKey = "${acme_path}/key.pem";

      root = "/srv/static";

      locations."/music/" = {
        extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;
        '';
      };
      locations."/.well-known/acme-challenge" = {
        root = "/var/lib/acme/acme-challenge";
      };
    };
  };

  # TLS-cert for https
  security.acme.certs."${fqdn}" = {
    domain = "${fqdn}";
    webroot = "/var/lib/acme/acme-challenge";
    postRun = "systemctl reload nginx";
  };
}