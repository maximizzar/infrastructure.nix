# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/ns/default.nix
{ inputs, ... }: {
  imports = [
    "${inputs.self}/modules/hardware/proxmox-disk-layout.nix"
    "${inputs.self}/modules/hardware/proxmox-qemu.nix"

    # Common settings
    "${inputs.self}/modules/services/common/networkd.nix"
    "${inputs.self}/modules/services/common/sshd.nix"
    "${inputs.self}/modules/services/common/pki.nix"

    # user setup (no home config for now)
    "${inputs.self}/modules/users/default.nix"

    # modules to configure the hosts role
    #"${inputs.self}/modules/services/powerdns/default.nix"
  ];

  networking.hostName = "ns";
  system.stateVersion = "25.11";
}
