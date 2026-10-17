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
      options.cliTooling = {
        enable = lib.mkEnableOption "Enable basic cli tooling";

        dev.enable = lib.mkEnableOption "development CLI tools";
        sys.enable = lib.mkEnableOption "system administration CLI tools";
        modern.enable = {
          type = lib.type.bool;
          description = "modern CLI replacements";
          default = cfg.enable;
        };

        config = lib.mkIf cfg.enable {
          environment.systemPackages =
            lib.optionals cfg.modern.enable (
              with pkgs;
              [
                bat
                eza
              ]
            )
            ++ lib.optionals cfg.dev.enable (
              with pkgs;
              [
                delta
                devenv
                git
                just
              ]
            )
            ++ lib.optionals cfg.sys.enable (
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
    };
}
