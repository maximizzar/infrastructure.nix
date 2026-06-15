# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Bootloader settings for systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # enable maximizzar user
  maximizzar.modules.users.maximizzar.enable = true;

  system.stateVersion = "26.05";

  # BIND9 directly on gw as dns "proxy"
  services.resolved.enable = false;

  networking.firewall.allowedTCPPorts = [ 53 80 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.bind = {
    enable = true;

    extraOptions = ''
      recursion yes;
    '';

    listenOnIpv6 = [
      "fd80:3aa8:691a:200::1"
    ];

    forwarders = [
      "2620:fe::11"
      "2620:fe::fe:11"
    ];
  };
}