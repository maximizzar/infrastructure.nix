# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.forgejoRunner =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.maximizzar.forgejoRunner;
    in
    {
      options.maximizzar.forgejoRunner = {
        enable = lib.mkEnableOption "Forgejo Runner Service";

        url = lib.mkOption {
          type = lib.types.str;
        };

        instances = lib.mkOption {
          default = { };
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = cfg.enable;
                };

                url = lib.mkOption {
                  type = lib.types.str;
                  default = cfg.url;
                };

                tokenFile = lib.mkOption {
                  type = lib.types.str;
                };

                labels = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                };

                hostPackages = lib.mkOption {
                  type = lib.types.listOf lib.types.package;
                  default = [ ];
                };

                capacity = lib.mkOption {
                  type = lib.types.int;
                  default = 1;
                };
              };
            }
          );
        };
      };

      config = lib.mkIf cfg.enable {
        services.gitea-actions-runner = {
          package = pkgs.forgejo-runner;

          instances = lib.mapAttrs (name: instance: {
            inherit (instance) enable url tokenFile;

            name = "${config.networking.hostName}-${name}";
            labels = [ "nixos:host" ] ++ instance.labels;
            hostPackages =
              with pkgs;
              [
                bash
                coreutils
                git
                nodejs
                nix
              ]
              ++ instance.hostPackages;
            settings.runner.capacity = instance.capacity;
          }) cfg.instances;
        };
      };

    };
}
