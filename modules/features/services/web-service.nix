# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.webService =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.webService;
      modules = with self.nixosModules; [
        acmeService
        webServer
      ];
    in
    {
      imports = modules;
      options.maximizzar.webService = {
        enable = lib.mkEnableOption "Web-Services defaults";
        openFirewall = lib.mkEnableOption "";

        fqdn = lib.mkOption {
          type = lib.types.str;
          default = config.networking.fqdn;
        };

        proxyPass = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "provide url with port, if backend does not use default http(s) ports";
        };
      };

      config = lib.mkIf cfg.enable {
        maximizzar.webServer = {
          enable = cfg.useWebserver;
          inherit (cfg) openFirewall;
        };

        services.nginx.virtualHosts."${cfg.fqdn}" = {
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
          locations."/".proxyPass = cfg.proxyPass;
        };
      };
    };
}
