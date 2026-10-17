# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, ... }: {
  imports = [
    ./dns-blocking.nix
    ./networking.nix
    ./pdns-recursor.nix
  ];

  options.maximizzar.modules.services.resolver = {
    enable = lib.mkEnableOption "Enable Resolver";
    blocklists.enable = lib.mkEnableOption "Enable DNS Blocking";
    openFirewall = lib.mkEnableOption "Open Ports in Firewall";

    forward_zones = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            zone = lib.mkOption {
              type = lib.types.str;
              description = "DNS zone to forward.";
            };

            forwarders = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "DNS servers to forward queries to.";
            };
          };
        }
      );

      default = [ ];
      description = "DNS forwarding zones.";
    };
  };
}
