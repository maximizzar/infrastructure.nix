-- SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
--
-- SPDX-License-Identifier: GPL-3.0-or-later

rpzFile("/etc/dns-blocklists/doh.txt", {
    policyName = "hagezi-block-doh",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/gambling.txt", {
    policyName = "hagezi-block-gambling",
    defpol = Policy.NXDOMAIN,
    tags = { "hagezi" }
})

rpzFile("/etc/dns-blocklists/hoster.txt", {
    policyName = "hagezi-block-hoster",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.amazon.txt", {
    policyName = "hagezi-block-amazon",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.apple.txt", {
    policyName = "hagezi-block-apple",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.huawei.txt", {
    policyName = "hagezi-block-huawei",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.lgwebos.txt", {
    policyName = "hagezi-block-lgwebos",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.oppo-realme.txt", {
    policyName = "hagezi-block-oppo-realme",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.roku.txt", {
    policyName = "hagezi-block-roku",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.samsung.txt", {
    policyName = "hagezi-block-samsung",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.tiktok.extended.txt", {
    policyName = "hagezi-block-tiktok",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.vivo.txt", {
    policyName = "hagezi-block-vivo",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.winoffice.txt", {
    policyName = "hagezi-block-winoffice",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})

rpzFile("/etc/dns-blocklists/native.xiaomi.txt", {
    policyName = "hagezi-block-xiaomi",
    defpol = Policy.NXDOMAIN,
    tags = {"hagezi"}
})
