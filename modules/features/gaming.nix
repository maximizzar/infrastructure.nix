# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    let
      modules = with self.nixosModules; [ steam ];
    in
    {
      imports = modules;
      hardware.graphics.enable = lib.mkDefault true;
      environment.systemPackages = with pkgs; [
        # Compat tools
        dxvk
        steam-run

        # Monitor and mgnt
        mangohud
        protonplus

        # Launcher
        prismlauncher
        itch
        dolphin-emu
      ];

      programs = {
        gamemode.enable = true;
        gamescope.enable = true;
      };

    };
}
