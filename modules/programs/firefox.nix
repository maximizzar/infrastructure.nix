# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.firefox =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.firefox = {
        enable = true;

        policies = {
          # Updates & Background Services
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;

          # Feature Disabling
          DisableTelemetry = true;

          # Access Restrictions
          BlockAboutConfig = false;
          BlockAboutProfiles = true;
          BlockAboutSupport = true;

          # UI and Behavior
          DontCheckDefaultBrowser = true;
          HardwareAcceleration = false;
          OfferToSaveLogins = false;
        };

        # key-value pairs in "about:config"
        preferences = {
          "browser.nova.enabled" = false;
        }
        // lib.optionalAttrs config.services.desktopManager.plasma6.enable {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };

        languagePacks = [ "de" ];
        nativeMessagingHosts.packages = lib.mkIf config.services.desktopManager.plasma6.enable [
          pkgs.kdePackages.plasma-browser-integration
        ];
      };
    };
}
