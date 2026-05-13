# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/common/nginx.nix
{ config, pkgs, ... }: {
  # NGINX base configuration
  services.nginx = {
    enable = true;
    validateConfigFile = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedUwsgiSettings = true;
    recommendedBrotliSettings = true;
  };
}
