# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, ... }: {
  imports = [
    ./acme.nix
    ./database.nix
    ./networking.nix
    ./nginx.nix
    ./server.nix
  ];

  options.maximizzar.modules.services.forgejo = {
    enable = lib.mkEnableOption "Enable the Forgejo Service";
    openFirewall = lib.mkEnableOption "Open Ports for forgejo server";

    passwordFile = lib.mkOption {
      type = lib.types.str;
    };
  };
}
