# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  modulesPath,
  lib,
  pkgs,
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

  services.resolved.enable = false;
  maximizzar.modules.services.resolver = {
    enable = true;
    openFirewall = true;

    forward_zones = [
      {
        zone = "maximizzar.org";
        forwarders = [
          "[fd80:3aa8:691a:ff53:52e5:75ff:fe61:13c7]:53"
        ];
      }

      {
        zone = "maximizzar.io";
        forwarders = [
          "[fd80:3aa8:691a:ff03:fcd4:d2ff:fe1d:db65]:53"
        ];
      }

    ];

  };

  environment.systemPackages = with pkgs; [
    curl
    dnsutils
  ];
}
