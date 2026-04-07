-- TCP/UDP Frontend (port 53)
addLocal("0.0.0.0:53", { reusePort=true })
addLocal("[::]:53",     { reusePort=true })

-- DoT Frontend (TLS, port 853)
addTLSLocal(
    "0.0.0.0:853",
    "@tlsCert@",
    "@tlsKey@",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

addTLSLocal(
    "[::]:853",
    "@tlsCert@",
    "@tlsKey@",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

-- DOH Frontend (HTTP/2, port 443)
addDOHLocal(
    "0.0.0.0:443",
    "@tlsCert@",
    "@tlsKey@",
    "/dns-query",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

addDOHLocal(
    "[::]:443",
    "@tlsCert@",
    "@tlsKey@",
    "/dns-query",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

-- DoH3 (HTTP/3 over QUIC, port 443)
addDOH3Local(
    "0.0.0.0:443",
    "@tlsCert@",
    "@tlsKey@",
    "/dns-query",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

addDOH3Local(
    "[::]:443",
    "@tlsCert@",
    "@tlsKey@",
    "/dns-query",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

-- Upstream: Quad9 via DoH (IPv6)
newServer({
    address     = "[2620:fe::fe]:443",
    tls         = "openssl",
    dohPath     = "/dns-query",
    subjectName = "dns.quad9.net",
    caStore     = "@caStore@",
    name        = "quad9-1",
    checkInterval = 10,
    checkName   = ".",
})

newServer({
    address     = "[2620:fe::9]:443",
    tls         = "openssl",
    dohPath     = "/dns-query",
    subjectName = "dns.quad9.net",
    caStore     = "@caStore@",
    name        = "quad9-2",
    checkInterval = 10,
    checkName   = ".",
})

setServerPolicy(firstAvailable)
