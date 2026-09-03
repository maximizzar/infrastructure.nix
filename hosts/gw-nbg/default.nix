# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# gw-nbg
{ inputs, ... }: {
  imports = [
    ./configuration.nix
    inputs.nixos-facter-modules.nixosModules.facter
    { hardware.facter.reportPath = ./facter.json; }
    ./disk-config.nix

    ./secrets.nix
    ./containers.nix
    ./networking.nix
    ./routing.nix
    ./wg.nix
  ];
}
