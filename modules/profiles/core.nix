# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/profiles/core.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # --- Text Editors ---
    nano
    vim

    # --- Network Tools ---
    curl
    wget

    # --- Modern Unix Replacements ---
    eza         # A modern replacement for 'ls'
    bat         # A 'cat' clone with wings (syntax highlighting)
    dust        # A more intuitive 'du' (Disk Usage)

    # --- Shell & Prompt ---
    starship    # The cross-shell customizable prompt
  ];
}
