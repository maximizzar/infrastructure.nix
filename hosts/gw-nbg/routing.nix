{ ... }: {
    # IPv6 Forwarding
    boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv6.conf.default.forwarding" = 1;
    };
}