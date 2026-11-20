# SPDX-FileCopyrightText: 2026 maximizzar <mail.maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  pkgs,
  lib,
  ...
}:
{
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

  fetchGrafanaDashboards =
    dashboards:
    lib.mapAttrs (
      name: dashboard:
      pkgs.fetchurl {
        name = "${name}.json";

        url =
          "https://grafana.com/api/dashboards/"
          + "${toString dashboard.id}/revisions/"
          + "${toString dashboard.revision}/download";

        inherit (dashboard) hash;
      }
    ) dashboards;

  mkGrafanaDashboardsBundle =
    dashboards:
    pkgs.runCommand "grafana-dashboards"
      {
        nativeBuildInputs = [ pkgs.jq ];
      }
      ''
        mkdir -p $out

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: source: ''
            jq '
              walk(
                if type == "string" then
                  gsub("\\$\\{DS_PROMETHEUS\\}|\\$DS_PROMETHEUS"; "prometheus")
                else
                  .
                end
              )
              | del(.__inputs)
            ' ${source} > $out/${name}.json
          '') dashboards
        )}
      '';
}
