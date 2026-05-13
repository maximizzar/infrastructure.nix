# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, lib, ... }: {
  services.immich = {
    enable = true;
    host = "::1";

    settings = {
      newVersionCheck.enabled = false;
      server.externalDomain = "https://immich.maximizzar.org";
    };

  };

  # Immich NGINX vHost configuration
  services.nginx.virtualHosts."immich.web.prod.maximizzar.org" = {
    quic = true;
    kTLS = true;

    http3 = true;
    http2 = true;

    locations."/" = {
      proxyPass = "http://[::1]:2283";
      proxyWebsockets = true;
      recommendedProxySettings = true;

      extraConfig = ''
        # add HTTP/3 Alt-Svc header
        add_header Alt-Svc 'h3=":443"; ma=86400' always;
      '';
    };
  };  
};
