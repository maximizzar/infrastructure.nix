# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.webServer =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.maximizzar.webServer;
      webConfig = {
        tls_server_config = {
          cert_file = "";
          key_file = "";

          client_auth_type = "RequireAndVerifyClientCert";
          client_ca_file = "";

          min_version = "TLS13";

          http_server_config = {
            http2 = true;
            headers = {
              X-Frame-Options = "deny";
            };
          };

        };

        basic_auth_users = builtins.listToAttrs (
          map (user: {
            inherit (user) name password;
          }) cfg.users
        );
      };

      webConfigFile = (pkgs.formats.yaml { }).generate "nginx-exporter-web-config.yml" webConfig;
    in
    {
      options.maximizzar.webServer = {
        enable = lib.mkEnableOption "Enable NGINX Web-server";
        openFirewall = lib.mkEnableOption "Open Ports 80/443 (TCP) and 443 UDP";
        package = lib.mkOption {
          default = pkgs.nginxMainline;
          defaultText = lib.literalExpression "pkgs.nginxMainline";
          type = lib.types.package;
        };

        metrics = {
          enable = lib.mkEnableOption "NGINX Metrics Exporter";
          openFirewall = lib.mkEnableOption "";

          users = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  name = lib.mkOption { type = lib.types.str; };
                  password = lib.mkOption { type = lib.types.str; };
                };
              }
            );
            default = [ ];
          };
        };
      };

      config = lib.mkIf cfg.enable {
        # NGINX Metrics Exporter Configuration
        services = {
          nginx.statusPage = cfg.metrics.enable;
          #maximizzar.metrics.targets.nginx.port = config.services.prometheus.exporters.nginx.port;
          prometheus.exporters.nginx = lib.mkIf cfg.metrics.enable {
            inherit (cfg.metrics) enable;

            extraFlags = [
              "--web.config.file=${webConfigFile}"
            ];
          };
        };

        # common NGINX settings
        services.nginx = {
          enable = true;
          package = pkgs.nginxMainline;
          enableReload = lib.mkDefault true;
          sslProtocols = lib.mkDefault "TLSv1.3";
          enableQuicBPF = lib.mkDefault true;
          recommendedBrotliSettings = lib.mkDefault true;
          recommendedTlsSettings = lib.mkDefault true;
          recommendedGzipSettings = lib.mkDefault true;
          recommendedOptimisation = lib.mkDefault true;
          recommendedProxySettings = lib.mkDefault true;
          recommendedUwsgiSettings = lib.mkDefault true;
        };

        # openFirewall option
        networking.firewall = lib.mkIf cfg.openFirewall {
          allowedTCPPorts = [
            80
            443
          ];
          allowedUDPPorts = [ 443 ];
        };

      };
    };

}
