# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  modulesPath,
  lib,
  stateVersion,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Hardware configuration
  maximizzar.modules.hardware.bootSystemd.enable = lib.mkDefault true;
  maximizzar.modules.hardware.configuration.qemu.enable = lib.mkDefault true;
  maximizzar.modules.hardware.rootDisk.enable = lib.mkDefault true;

  # Core Services
  services.openssh.enable = lib.mkDefault true;
  services.qemuGuest.enable = lib.mkDefault true;

  # User Settings
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  users.users.maximizzar.enable = true;

  system.stateVersion = stateVersion;

}
