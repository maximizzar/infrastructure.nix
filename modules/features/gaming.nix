# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosModules.gaming = { pkgs, lib, ... }: {
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

    programs.steam = {
      enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
