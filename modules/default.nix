# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/default.nix
{ ... }: {
    imports = [
        ./hardware   # physical / VM / platform-specific
        ./networking # routing, DNS, firewall rules, VPN, proxy layers
        ./programs   # user-facing tools (cli apps, desktop apps)
        ./services   # daemons (dns, web, ssh, etc.)
        ./system     # core OS behavior (boot, kernel, filesystems, networking base)
        ./users      # user + permissions + shells
        ./vars       # shared constants / config data
    ];
}
