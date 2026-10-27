# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.authelia;
in
{
  imports = [
    ./access_control.nix
    ./cookies.nix
    ./clients
    ./secrets.nix
    ./server.nix
    ./settings.nix
  ];

  options.maximizzar.modules.services.authelia = {
    enable = lib.mkEnableOption "Enable Authelia for maximizzar.org domain";

    jwtSecretFile = lib.mkOption {
      type = lib.types.str;
    };

    oidcHmacSecretFile = lib.mkOption {
      type = lib.types.str;
    };

    oidcIssuerPrivateKeyFile = lib.mkOption {
      type = lib.types.str;
    };

    sessionSecretFile = lib.mkOption {
      type = lib.types.str;
    };

    storageEncryptionKeyFile = lib.mkOption {
      type = lib.types.str;
    };

    usersDatabase = lib.mkOption {
      type = lib.types.str;
    };

  };

  config = lib.mkIf cfg.enable {
    services.authelia.instances."maximizzar.org" = {
      enable = true;
    };
  };

}
