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
  cfg = config.maximizzar.modules.services.forgejoRunner;
in
{
  options.maximizzar.modules.services.forgejoRunner = {
    enable = lib.mkEnableOption "forgejo-runner";

    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "User under which the runner is executed.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "Group under which the runner is executed.";
    };

    uuid = lib.mkOption {
      type = lib.types.str;
      description = "Forgejo-Runner UUID from forgejo server";
    };

    forgejoInstanceUrl = lib.mkOption {
      type = lib.types.str;
      description = "URL to the Forgejo Instance the runner should connect to";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.forgejo-runner = {
      description = "forgejo-runner";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        bash
        coreutils
        git
        nodejs
        pkgs.forgejo-runner
        nix
        "/run/current-system/sw"
      ];

      environment = {
        FORGEJO_INSTANCE_URL = cfg.forgejoInstanceUrl;
        NIX_REMOTE = "daemon";
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "/var/lib/forgejo-runner";
        ExecStart = "${pkgs.forgejo-runner}/bin/forgejo-runner daemon --url ${cfg.forgejoInstanceUrl}/ --uuid ${cfg.uuid} --token-url file:///var/secrets/forgejo-runner/token --label nixos:host";

        Restart = "always";
        RestartSec = "5s";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/forgejo-runner 0700 ${cfg.user} ${cfg.group} - -"
    ];
  };
}
