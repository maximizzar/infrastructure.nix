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

                uuid = lib.mkOption {
                  type = lib.types.str;
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

      config = lib.mkIf cfg.enable (
        let
          yaml = pkgs.formats.yaml { };

          baseHostPackages = with pkgs; [
            bash
            coreutils
            curl
            gawk
            gitMinimal
            gnused
            nodejs
            wget

            nix
          ];
        in
        {
          systemd.services = lib.mapAttrs' (
            name: instance:
            let
              unit = "forgejo-runner-${name}";

              configFile = yaml.generate "${unit}.yml" {
                runner = {
                  inherit (instance) capacity;

                  timeout = "1h";
                  shutdown_timeout = "30s";
                  labels = [ "nixos:host" ] ++ instance.labels;
                };
                server.connections = {
                  "${name}" = {
                    inherit (instance) url uuid;
                    token_url = "file:///run/credentials/${unit}.service/token";
                    fetch_interval = "30s";
                  };
                };
              };
            in
            lib.nameValuePair unit {
              description = "Forgejo runner ${name}";
              wantedBy = [ "multi-user.target" ];
              wants = [ "network-online.target" ];
              after = [ "network-online.target" ];

              path = baseHostPackages ++ instance.hostPackages;
              environment.HOME = "/var/lib/${unit}";
              restartIfChanged = false;

              serviceConfig = {
                ExecStart = lib.escapeShellArgs [
                  (lib.getExe pkgs.forgejo-runner)
                  "daemon"
                  "--config"
                  configFile
                ];
                LoadCredential = "token:${instance.tokenFile}";

                DynamicUser = true;
                StateDirectory = unit;
                WorkingDirectory = "/var/lib/${unit}";
                Restart = "on-failure";
                RestartSec = 5;

                PrivateTmp = true;
                ProtectHome = true;
                NoNewPrivileges = true;
              };
            }
          ) (lib.filterAttrs (_: instance: instance.enable) cfg.instances);
        }
      );
    };

}
