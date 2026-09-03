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
  disko.devices.disk.main.imageSize = "32G";

  # Core Services
  services.openssh.enable = lib.mkDefault true;
  services.qemuGuest.enable = lib.mkDefault true;

  # Networking
  networking = {
    hostName = "runner";
    nameservers = [ "fd19:38bc:a21d:1abf:be24:11ff:fedf:ac9d" ];
  };
  maximizzar.networking.vmNetworking.enable = true;
  maximizzar.networking.ipForwarding.enable = true;
  maximizzar.networking.containerNetworking.enable = true;

  # User Settings
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  users.users.maximizzar.enable = true;

  system.stateVersion = stateVersion;
}
