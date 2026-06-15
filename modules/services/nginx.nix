# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib, ... }: {
  services.nginx = {
    validateConfigFile = lib.mkDefault true;

    recommendedTlsSettings = lib.mkDefault true;
    recommendedOptimisation = lib.mkDefault true;

    recommendedGzipSettings = lib.mkDefault true;
    recommendedUwsgiSettings = lib.mkDefault true;
    recommendedBrotliSettings = lib.mkDefault true;
    recommendedProxySettings = lib.mkDefault true;
  };
}
