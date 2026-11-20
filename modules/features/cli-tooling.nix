# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
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

      imports =
        let
          modern = with self.nixosModules; [ bat ];
          dev = with self.nixosModules; [ lazygit ];
          sys = with self.nixosModules; [
            bandwhich
            htop
          ];
        in
        lib.options cfg.modern modern ++ lib.options cfg.dev dev ++ lib.options cfg.sys sys;

      config = lib.mkIf cfg.enable {
        environment.systemPackages =
          lib.optionals cfg.modern (
            with pkgs;
            [
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
              btop
              curl
              dust
              duf
              wget
            ]
          );

        programs.starship.enable = lib.mkDefault cfg.modern;
      };

    };

}
