# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.acmeService =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.acmeService;
      modules = with self.nixosModules; [ ];
    in
    {
      imports = modules;

      options.maximizzar.acmeService = {
        enable = lib.mkEnableOption "";

        domain = lib.mkOption {
          type = lib.types.str;
          default = config.networking.fqdn;
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "nginx";
        };

        reloadServices = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "${cfg.group}.service" ];
        };
      };

      config = lib.mkIf cfg.enable {
        security.acme.certs.${cfg.domain} = {
          inherit (cfg) domain group reloadServices;
          webroot = "/var/lib/acme/acme-challenge";
        };
      };
    };
}
