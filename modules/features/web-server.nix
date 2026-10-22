# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.webServer = { lib, pkgs, ... }: {
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

    # allow default http(s) ports TCP/UDP
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [ 443 ];
  };
}
