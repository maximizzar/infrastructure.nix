# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  pkgs,
  config,
  lib,
  ...
}:
let
  forgejoUrl = "https://forgejo.maximizzar.io";
in
{
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;

    instances."1" = {
      enable = true;
      name = config.networking.hostName;

      url = forgejoUrl;

      tokenFile = "/var/secrets/forgejo-runner/token";

      labels = [
        "nixos:host"
        "native:host"
      ];

      settings = {
        container.network = "host";
        log.level = "debug"; # have logs of the jobs appear in system logs
      };

      hostPackages = with pkgs; [
        bash
        coreutils
        curl
        gawk
        git
        nodejs
        wget
      ];

      #nix.settings.trusted-users = [ "gitea-runner-host-runner" ];
    };
  };

  systemd.services.gitea-runner-1.serviceConfig = {
    User = lib.mkForce "root";
    Group = lib.mkForce "root";
  };
}
