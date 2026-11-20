# SPDX-FileCopyrightText: 2026 maximizzar <mail.maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.metrics =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.metrics;
      modules = [
        ./_certs.nix
        ./_node.nix
      ];
    in
    {
      options.maximizzar.metrics = {
        enable = lib.mkEnableOption "Metrics Exporting";
        domain = lib.mkOption {
          type = lib.types.str;
          default = "metrics." + config.networking.fqdn;
          description = "Under what FQDN metrics should be exposed.";
        };

        allowedScrapers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "";
        };

        targets = lib.mkOption {
          default = { };
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                port = lib.mkOption { type = lib.types.port; };
                path = lib.mkOption {
                  type = lib.types.str;
                  default = "/metrics";
                };
                labels = lib.mkOption {
                  type = lib.types.attrsOf lib.types.str;
                  default = { };
                };
              };
            }
          );
        };

      };

      imports = modules;
      config = lib.mkIf cfg.enable {
        networking.firewall.extraInputRules = lib.concatStrings (
          lib.concatMap (
            t: map (ip: "ip saddr ${ip} tcp dport ${toString t.port} accept\n") cfg.allowedScrapers
          ) (lib.attrValues cfg.targets)
        );

        services.nginx.virtualHosts."metrics" = {
          serverName = cfg.domain;

          sslCertificate = "/var/lib/acme/${cfg.domain}/fullchain.pem";
          sslCertificateKey = "/var/lib/acme/${cfg.domain}/key.pem";
          sslTrustedCertificate = "/var/lib/acme/${cfg.domain}/chain.pem";

          forceSSL = true;
          kTLS = true;
          enableACME = true;

          quic = true;
          extraConfig = ''
            add_header Alt-Svc 'h3=":443"; ma=86400' always;
          '';
        };
      };
    };
}
