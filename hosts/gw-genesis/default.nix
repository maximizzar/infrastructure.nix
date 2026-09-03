# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# gw-genesis
{ inputs, ... }: {
  imports = [
    ./configuration.nix
    inputs.nixos-facter-modules.nixosModules.facter
    { hardware.facter.reportPath = ./facter.json; }
    ./disk-config.nix

    ./containers.nix

    # Networking
    ./networking-dmz.nix
    ./networking-srv.nix

    ./wg.nix

    # Secrets
    ./secrets.nix
  ];
}
