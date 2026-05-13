# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/core/nameserver/authoritive.nix
{ self, pkgs, hostname, domain, ...  }: let
    fqdn = hostname + "." + domain;

    # SOA Record fields
    serial = self.lastModified;
    refresh = "3600";
    retry = "1800";
    expire = "604800";
    minimum = "86400";

    forwardZone = pkgs.replaceVars ./zones/${domain}.zone {
        DOMAIN = domain;

        SERIAL = serial;
        REFRESH = refresh;
        RETRY = retry;
        EXPIRE = expire;
        MINIMUM = minimum;
    };
    reverseZone = pkgs.replaceVars ./zones/a.1.9.6.8.a.a.3.0.8.d.f.ip6.arpa.zone {
        DOMAIN = domain;

        SERIAL = serial;
        REFRESH = refresh;
        RETRY = retry;
        EXPIRE = expire;
        MINIMUM = minimum;
    };

    namedConf = pkgs.replaceVars ./config/named.conf {
        DOMAIN = domain;
    };

in {
    networking.hostName = hostname;
    networking.domain = domain;
    services.resolved.enable = false;
    networking.firewall.enable = true;
    networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
    };

    environment.systemPackages = with pkgs; [
        dnsutils
    ];

    services.powerdns = {
        enable = true;
        extraConfig = ''
            launch=bind
            bind-config=/var/lib/powerdns/named.conf
        '';
    };

    # Install BIND9 base config
    environment.etc = {
        "powerdns/zones/${domain}.zone".source = forwardZone;
        "powerdns/zones/a.1.9.6.8.a.a.3.0.8.d.f.ip6.arpa.zone".source = reverseZone;
        "powerdns/named.conf".source = namedConf;
    };

    # Create symlink for PowerDNS
    system.activationScripts.powerdns-setup = ''
        mkdir -p /var/lib/powerdns
        ln -sf /etc/powerdns/named.conf /var/lib/powerdns/named.conf
    '';
}
