# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/profiles/desktop.nix
{ pkgs, ... }: {
  imports = [
    ./core.nix
    ./home-bridge.nix
  ];

  environment.systemPackages = with pkgs; [
    # --- Text Editors ---
    neovim

    # --- Network Tools ---
    btop
    bandwhich   # Bandwidth utilization by process
  ];
}
