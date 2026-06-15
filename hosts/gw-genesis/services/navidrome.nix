# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inventory, ... }: let
  #TODO: Generalize more and move hosts out of context!
  hosts = inventory.sites.genesis.router.interfaces.lan.hosts;
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];
  services.nginx = {
    enable = true;
    validateConfigFile = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedUwsgiSettings = true;
    recommendedBrotliSettings = true;
    recommendedProxySettings = true;

    virtualHosts."${hosts.navidrome.fqdn}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:4533";
      };
    };
  };

  services.navidrome = {
    enable = true;

    settings = {
      MusicFolder = "/mnt/music";
      LogLevel = "WARN";

      DefaultTheme = "Gruvbox Dark";

      Scanner.GroupAlbumReleases = true;
    };

  };
}