# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, lib, ... }: {
  # Jellyfin Service configuration
  services.jellyfin = {
    enable = true;
    openFirewall = false;
  };

  # Jellyfin systemd configuration + socket
  systemd.services.jellyfin = {
    environment = {
      #JELLYFIN_PublishedServerUrl = "https://jellyfin.maximizzar.org";

      # Enable Unix socket
      JELLYFIN_kestrel__socket = "true";
      JELLYFIN_kestrel__socketPath = "/run/jellyfin/jellyfin.sock";
      JELLYFIN_kestrel__socketPermissions = "0660";

    };

    serviceConfig = {
      RuntimeDirectory = "jellyfin";
      RuntimeDirectoryMode = "0750";
      SupplementaryGroups = [ "jellyfin" ];
    };
  };

  # nginx needs to be in the jellyfin group to read the socket
  users.users.nginx.extraGroups = [ "jellyfin" ];

  # Jellyfin NGINX vHost configuration
  services.nginx.virtualHosts."jellyfin.web.prod.maximizzar.org" = {
    quic = true;
    kTLS = true;

    http3 = true;
    http2 = true;

    locations."/" = {
      proxyPass = "http://[::1]:8096";
      proxyWebsockets = true;
      recommendedProxySettings = true;

      extraConfig = ''
        # add HTTP/3 Alt-Svc header
        add_header Alt-Svc 'h3=":443"; ma=86400' always;

        # Security / XSS Mitigation Headers
        # NOTE: X-Frame-Options may cause issues with the webOS app
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-Content-Type-Options "nosniff";

        # Permissions policy. May cause issues on some clients
        add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;
      '';
    };

    enableACME = true;
    serverAliases = [
      "www.jellyfin.web.prod.maximizzar.org"
    ];
  };
};
