# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.webServer =
    { config, lib, ... }:
    let
      modules = [
        ./_nginx.nix
        ./_exporter.nix
      ];
    in
    {
      imports = modules;
      options.maximizzar.webServer = {
        metrics = {
          enable = lib.mkOption {
            default = config.maximizzar.metrics.enable;
            description = "NGINX protected metrics";
          };

          domain = lib.mkOption {
            type = lib.types.str;
            description = "Under which domain the hosts metrics will be exposed.";
            default = config.maximizzar.metrics.domain;
          };

          users = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  name = lib.mkOption { type = lib.types.str; };
                  password = lib.mkOption { type = lib.types.str; };
                };
              }
            );
            default = [ ];
          };

        };
      };

      config = {
        networking.firewall = {
          allowedTCPPorts = [
            80
            443
          ];
          allowedUDPPorts = [ 443 ];
        };

      };
    };

}
