# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.forgejo =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.forgejo;
    in
    {
      imports = with self.nixosModules; [
        webServer
      ];

      options.maximizzar.forgejo = {
        enable = lib.mkEnableOption "Enable the Forgejo Service";
        openFirewall = lib.mkEnableOption "Open all relevant Ports ";

        baseDomain = lib.mkOption {
          type = lib.types.str;
          default = "maximizzar.org";
        };

        fqdn = lib.mkOption {
          type = lib.types.str;
          default = config.networking.fqdn;
        };

        repositoryRoot = lib.mkOption {
          type = lib.types.str;
          default = "/mnt/repositories";

        };

        passwordFile = lib.mkOption {
          type = lib.types.str;
        };

      };

      config = lib.mkIf cfg.enable {
        maximizzar.webServer = {
          inherit (cfg) enable openFirewall;
        };

        # ACME
        security.acme.certs.${cfg.fqdn} = {
          domain = cfg.fqdn;
          webroot = "/var/lib/acme/acme-challenge";
          postRun = "systemctl reload nginx";
        };

        services = {
          # Database
          postgresql = {
            inherit (cfg) enable;

            ensureUsers = [
              {
                name = config.services.forgejo.user;
                ensureDBOwnership = true;
              }
            ];

            ensureDatabases = [
              config.services.forgejo.database.name
            ];

          };

          # VHost configuration
          nginx.virtualHosts."forgejo" = {
            serverName = cfg.fqdn;

            sslCertificate = "/var/lib/acme/${cfg.fqdn}/fullchain.pem";
            sslCertificateKey = "/var/lib/acme/${cfg.fqdn}/key.pem";
            sslTrustedCertificate = "/var/lib/acme/${cfg.fqdn}/chain.pem";

            forceSSL = true;
            kTLS = true;
            enableACME = true;

            quic = true;
            extraConfig = ''
              add_header Alt-Svc 'h3=":443"; ma=86400' always;
            '';

            locations."/".proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:";
          };

          forgejo = {
            inherit (cfg) enable repositoryRoot;
            lfs.enable = true;

            settings = {
              DEFAULT = {
                APP_NAME = "Forgejo <maximizzar.org>";
                APP_SLOGAN = "Yet another forgejo instance!";
              };

              server = {
                DOMAIN = "${cfg.fqdn}";
                ROOT_URL = "https://forgejo.${cfg.baseDomain}/";
                SSH_DOMAIN = "ssh.forgejo.${cfg.baseDomain}";

                PROTOCOL = "http+unix";
              };
              session.COOKIE_SECURE = true;

              service = {
                ENABLE_CAPTCHA = false;
                DISABLE_REGISTRATION = true;
                REQUIRE_SIGNIN_VIEW = false;
              };

              oauth2_client = {
                ENABLE_AUTO_REGISTRATION = true;
              };
            };
          };

        };

      };
    };
}
