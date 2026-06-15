# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  modulesPath,
  lib,
  pkgs,
  inventory,
  ...
}@args: let
  sites = inventory.sites;
  nbg = inventory.sites.nbg.router.interfaces.lan;
  genesis = inventory.sites.genesis.router.interfaces.lan;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # enable maximizzar user
  maximizzar.modules.users.maximizzar.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  system.stateVersion = "26.05";

  # BIND9 directly on gw as dns "proxy"
  services.resolved.enable = false;

  networking.firewall.allowedTCPPorts = [ 53 80 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.bind = {
    enable = true;

    listenOnIpv6 = [
      "fd80:3aa8:691a:100::1"
    ];

    forwarders = [
      "2620:fe::11"
      "2620:fe::fe:11"
    ];
  };
}