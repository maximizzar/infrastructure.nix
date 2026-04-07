# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/nameserver/default.nix
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    "${inputs.self}/modules/services/common/pki.nix"
    "${inputs.self}/modules/users/default.nix"
    "${inputs.self}/modules/services/powerdns/default.nix"
  ];

  networking.hostName = "ns";
  services.resolved.enable = false;
  system.stateVersion = "25.11";
}
