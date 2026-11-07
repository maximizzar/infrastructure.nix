# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.cliTooling =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.maximizzar.cliTooling;
    in
    {
      options.maximizzar.cliTooling = {
        enable = lib.mkEnableOption "Enable basic cli tooling";

        dev = lib.mkEnableOption "development CLI tools";
        sys = lib.mkEnableOption "system administration CLI tools";
        modern = lib.mkOption {
          type = lib.types.bool;
          description = "modern CLI replacements";
          default = cfg.enable;
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages =
          lib.optionals cfg.modern (
            with pkgs;
            [
              bat
              eza
            ]
          )
          ++ lib.optionals cfg.dev (
            with pkgs;
            [
              delta
              devenv
              git
              just
            ]
          )
          ++ lib.optionals cfg.sys (
            with pkgs;
            [
              bandwhich
              btop
              curl
              htop
              dust
              duf
              wget
            ]
          );

        programs.starship.enable = lib.mkDefault cfg.modern;
      };

    };

}
