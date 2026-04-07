# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/profiles/lxc.nix
{ pkgs, ... }: {
  imports = [
    ./core.nix
    #./home-bridge.nix
    ../services/common/avahi.nix
    ../services/common/pki.nix
    ../services/common/sshd.nix
  ];

  system.stateVersion = "25.11";

  #services.resolved.enable = true;
  #networking.useNetworkd = true;
  #networking.useDHCP = true;

  #systemd.network.networks."10-eth0" = {
  #  matchConfig.Name = "eth*"; # Match physical or virtual ethernet
  #  networkConfig = {
  #    DHCP = "yes";
  #    IPv6AcceptRA = true;
  #  };

  #  dhcpV4Config.UseDNS = true;
  #  dhcpV6Config.UseDNS = true;
  #  ipv6AcceptRAConfig.UseDNS = true;
  #};
}
