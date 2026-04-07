# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, lib, ... }: {
  # Install system Packages needed for Navidrome Setup
  environment.systemPackages = with pkgs; [
    navidrome
  };

  # Navidrome Service configuration
  services.navidrome = {
    Port = 4533;
    Address = "::1";
    enable = true;
    settings = {
      MusicFolder = '/media/music/default'
    };
  };

  # NGINX Service configuration
  services.nginx = {
    enable = true;
    validateConfigFile = true;

    # Global Config Options
    clientMaxBodySize = "16m"

    # Navidrome VHost
    virtualHosts.navidrome = {
      serverName = "navidrome.maximizzar.org";
      enableACME = true;
      quic = true;
      kTLS = true;
      http3 = true;
      http2 = true;
      forceSSL = true;

      # Locations
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://[::1]:4533";
      };
    };
  };
}
