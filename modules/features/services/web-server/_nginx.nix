# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
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
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;
    sslProtocols = lib.mkDefault "TLSv1.3";
    enableQuicBPF = lib.mkDefault true;
    recommendedBrotliSettings = lib.mkDefault true;
    recommendedTlsSettings = lib.mkDefault true;
    recommendedGzipSettings = lib.mkDefault true;
    recommendedOptimisation = lib.mkDefault true;
    recommendedProxySettings = lib.mkDefault true;
    recommendedUwsgiSettings = lib.mkDefault true;

  };
}
