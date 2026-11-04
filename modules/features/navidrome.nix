# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.navidrome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.maximizzar.navidrome;
    in
    {
      imports = with self.nixosModules; [
        webServer
      ];

      options.maximizzar.navidrome = {
        enable = lib.mkEnableOption "Navidrome Service";
        openFirewall = lib.mkEnableOption "Open Ports 80/443 (TCP) and 443 UDP";

        subdomain = lib.mkOption {
          type = lib.types.str;
          default = config.networking.hostName;
        };

        domain = lib.mkOption {
          type = lib.types.str;
          default = "maximizzar.org";
        };

        fqdn = lib.mkOption {
          type = lib.types.str;
          default = config.networking.fqdn;
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
          # Navidrome Service configuration
          navidrome = {
            inherit (cfg) enable;

            plugins = with pkgs.navidromePlugins; [
              apple-music
              listenbrainz-daily-playlist
            ];

            settings = {
              # Basic configuration
              MusicFolder = "/mnt/music";
              LogLevel = "WARN";
              Address = "unix:/server.socket";
              BaseUrl = "https://${cfg.subdomain}.${cfg.domain}";
              EnableInsightsCollector = true;

              # Advanced configuration
              CoverArtQuality = 100;
              DefaultTheme = "Gruvbox Dark";
              DefaultUIVolume = 50;
              EnforceNonRootUser = true;
              EnableArtworkUpload = false;
              # Sort names containing numbers in human order (Foo 2 before Foo 10).
              # Off by default because it can slow down large libraries, see #6015
              EnableNaturalSorting = false;
              EnableWebPEncoding = true;
              ImageCacheSize = "256GB";
              LastFM = {
                Enabled = false;
                ApiKey = ""; # TODO add key with sops
                Secret = ""; # TODO add key with sops
                Language = "de,en";
              };
              PasswordEncryptionKey = ""; # TODO add key with sops
              Prometheus = {
                Enabled = false;
                Password = ""; # TODO add key with sops
              };
              RecentlyAddedByModTime = false;

              Scanner = {
                WatcherWait = "30s";
                ScanOnStartup = false;
                PurgeMissing = "never";
              };
              SessionTimeout = "32h";
              Subsonic = {
                ArtistParticipations = true;
                EnableAverageRating = false;
              };
              Transcoding = {
                EnableCancellation = true;
                MaxConcurrent = 8;
                MaxConcurrentPerUser = 3;
              };
              TranscodingCacheSize = "150MiB";
              UICoverArtSize = 800;
              UIPlaybackReportInterval = "45s";
            };
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
            locations."/".proxyPass = "http://unix:/run/navidrome/server.socket:/";
          };

        };
      };

    };
}
