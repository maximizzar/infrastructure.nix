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
      };

      config = lib.mkIf cfg.enable {

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
