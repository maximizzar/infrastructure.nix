# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/vars/network.nix
{ lib, ... }: let
    mkSubnet = { prefix, prefixLength, vlan ? null, description ? "" }: {
        inherit prefix prefixLength vlan description;
        cidr = "${prefix}::/${toString prefixLength}";
        net = "${prefix}::";
        gateway = "${prefix}::1";
        address = addr: "${prefix}::${addr}";

        # Reverse DNS Zone
        reverseZone = let
            parts = lib.splitString ":" prefix;
            nibbles = lib.concatStrings (lib.take 4 (lib.concatMap (p: lib.stringToCharacters p) parts));
        in "${nibbles}.ip6.arpa";
    };

    prefix = "fd80:3aa8:691a";

in {
    flake.network = rec {
        # Main ULA Prefix
        net = {
            prefix = prefix;
            prefixLength = 48;
        };

        subnets = {
            management = mkSubnet {
                prefix = "${prefix}:0010";
                prefixLength = 64;
                vlan = 10;
                description = "Management network";
            };

            core = mkSubnet {
                prefix = "${prefix}:0020";
                prefixLength = 64;
                vlan = 20;
                description = "core services network";
            };

            vc = mkSubnet {
                prefix = "${prefix}:0030";
                prefixLength = 64;
                vlan = 30;
                description = "Version Control services network";
            };

            web = mkSubnet {
                prefix = "${prefix}:0040";
                prefixLength = 64;
                vlan = 40;
                description = "Web services network";
            };
        };
    };
}
