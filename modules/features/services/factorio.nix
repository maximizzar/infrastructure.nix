# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.factorio =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      factorio-headless-no-space-age = pkgs.factorio-headless.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          rm -rf $out/share/factorio/data/space-age
          rm -rf $out/share/factorio/data/quality
          rm -rf $out/share/factorio/data/elevated-rails
        '';
      });

      cfg = config.maximizzar.factorio;
    in
    {
      options.maximizzar.factorio = {
        enable = lib.mkEnableOption "Enable factorio server module";
        openFirewall = lib.mkEnableOption "Open factorio port in FW";
      };

      config = lib.mkIf cfg.enable {
        services.factorio = {
          inherit (cfg) enable openFirewall;

          admins = [ "maximizzar" ];
          allowedPlayers = config.services.factorio.admins ++ [
            "Daven"
            "Jolfudr-"
          ];

          autosave-interval = 15;
          description = "Base Factorio game in version 2.x";
          package = factorio-headless-no-space-age;

          loadLatestSave = true;
          nonBlockingSaving = true;

          saveName = "world";
          username = "maximizzar";
        };

        nixpkgs.config.allowUnfree = true;
      };

    };
}
