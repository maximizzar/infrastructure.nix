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
  maximizzar.modules.users.maximizzar.enable = lib.mkDefault true;

  services.resolved.enable = false;

  environment.systemPackages = with pkgs; [
    curl
    dnsutils
  ];

  system.stateVersion = "26.05";

  containers.ns = {
    autoStart = true;
    restartIfChanged = true;

    privateNetwork = true;
    hostBridge = "br1";
    localMacAddress = "50:E5:75:61:13:C7";

    config = { ... }: {
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      systemd.network.enable = true;
      services.resolved.enable = false;

      boot.kernel.sysctl = {
        "net.ipv6.conf.all.accept_ra" = 2;
        "net.ipv6.conf.eth0.accept_ra" = 2;
      };

      systemd.network.networks."10-eth0" = {
        matchConfig.Name = "eth0";

        networkConfig = {
          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = "kernel";
        };
      };

      imports = [
        ./authoritative.nix
      ];

      system.stateVersion = "26.05";
    };

  };
}
