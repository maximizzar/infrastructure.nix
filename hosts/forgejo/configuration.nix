# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  modulesPath,
  config,
  lib,
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
  disko.devices.disk.main = {
    imageSize = "16G";
    content.partitions.root.priority = 3;
  };

  # Add Partitons for git repositories
  disko.devices.disk.main.content.partitions = {
    repositories = {
      priority = 2;
      name = "repositories";
      size = "8G";

      content = {
        type = "filesystem";
        format = "ext4";
        mountpoint = "/mnt/repositories";
        mountOptions = [ "noatime" ];
      };
    };
  };

  # Core Services
  services.qemuGuest.enable = lib.mkDefault true;

  # Networking
  networking.hostName = "forgejo";
  maximizzar.networking.vmNetworking.enable = true;

  # User Settings
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  users.users.maximizzar.enable = true;

  maximizzar.modules.services.forgejo = {
    enable = true;
    openFirewall = true;

    passwordFile = config.sops.secrets."forgejo_database/password".path;
  };
}
