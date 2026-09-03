# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  modulesPath,
  lib,
  inventory,
  ...
}:
let
  site = inventory.sites.genesis;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Hardware configuration
  maximizzar.modules.hardware.bootSystemd.enable = lib.mkDefault true;

  # Core Services
  services.openssh.enable = lib.mkDefault true;
  services.qemuGuest.enable = lib.mkDefault true;

  # Networking
  networking = {
    hostName = "gw";
  };

  maximizzar.networking.vmNetworking.enable = true;
  maximizzar.networking.ipForwarding = {
    enable = true;
    PrefixDelegationHint = "::/62";
  };

  maximizzar.networking.containerNetworking = {
    enable = true;
    mac = site.hosts.gw.interfaces.br-container.mac;
    subnetId = "0";
    ulaPrefix = site.networks.gwbr.Prefix;
  };

  # User Settings
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  users.users.maximizzar.enable = true;

  maximizzar.modules.services.proxy = {
    enable = true;
    environmentFile = config.sops.secrets.ionos-acme.path;

    authelia.enable = true;
    forgejo.enable = true;
  };

  networking.firewall.enable = false;

  networking.firewall = {
    allowedTCPPorts = [
      53
      80
      443
    ];
    allowedUDPPorts = [
      53
      443
    ];
  };

}
