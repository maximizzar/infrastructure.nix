# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # bitwarden-desktop # currently insecure Electorn version
    git
    ffmpeg

    home-manager
    keepassxc
    translate-shell

    jellyfin-desktop

    maple-mono.NF-CN

    # Rust cli tools
    bandwhich
  ];

  maximizzar.modules.services.libvirt.enable = true;
}
