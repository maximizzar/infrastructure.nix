# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, ... }: {
  imports = [
    ./acme.nix
    ./nginx.nix
  ];

  options.maximizzar.modules.services.proxy = {
    enable = lib.mkEnableOption "Enable Proxy Module";

    environmentFile = lib.mkOption {
      type = lib.types.str;
    };

    authelia.enable = lib.mkEnableOption "Enable Authelia Proxy";
    forgejo.enable = lib.mkEnableOption "Enable Forgejo Proxy";
    prometheus.enable = lib.mkEnableOption "Enable Prometheus Proxy";
  };
}
