# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ pkgs, ... }:
let
  factorio-headless-no-space-age = pkgs.factorio-headless.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      rm -rf $out/share/factorio/data/space-age
      rm -rf $out/share/factorio/data/quality
      rm -rf $out/share/factorio/data/elevated-rails
    '';
  });
in
{
  nixpkgs.config.allowUnfree = true;

  services.factorio = {
    enable = true;

    admins = [ "maximizzar" ];
    allowedPlayers = [
      "maximizzar"
      "Daven"
      "Jolfudr-"
    ];

    autosave-interval = 15;
    description = "Base Factorio game in version 2.x";
    package = factorio-headless-no-space-age;

    loadLatestSave = true;
    nonBlockingSaving = true;
    openFirewall = true;
    saveName = "world";
    username = "maximizzar";

  };
}
