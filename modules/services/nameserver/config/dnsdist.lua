-- ==========================================
-- 1. FRONTENDS (This is where the clients arrive.)
-- ==========================================

-- TCP/UDP Frontend (port 53)
addLocal("[::]:53", { reusePort=true })

-- Loopback for recursor
addLocal("127.0.0.1:5353", { reusePort=true })

-- DoT Frontend (TLS, port 853)
addTLSLocal(
    "[::]:853",
    "@tlsCert@",
    "@tlsKey@",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

-- DOH Frontend (HTTP/2, port 443)
addDOHLocal(
    "[::]:443",
    "@tlsCert@",
    "@tlsKey@",
    "/dns-query",
    { reusePort=true, minTLSVersion="@minTLS@" }
)

-- ==========================================
-- 2. BACKENDS & POOLS
-- ==========================================

-- local PowerDNS Recursor (Pool: "recursor")
newServer({
    address         = "127.0.0.1:5300",
    name            = "pdns-recursor",
    pool            = "recursor",
    checkName       = ".",
    checkInterval   = 5,
    useClientSubnet = false,
})

-- Upstream: Quad9 via DoH (IPv6)
newServer({
    address       = "[2620:fe::fe]:443",
    tls           = "openssl",
    dohPath       = "/dns-query",
    subjectName   = "dns.quad9.net",
    caStore       = "@caStore@",
    name          = "quad9-1",
    pool          = "quad9",
    checkInterval = 10,
    checkName     = ".",
})

newServer({
    address       = "[2620:fe::9]:443",
    tls           = "openssl",
    dohPath       = "/dns-query",
    subjectName   = "dns.quad9.net",
    caStore       = "@caStore@",
    name          = "quad9-2",
    pool          = "quad9",
    checkInterval = 10,
    checkName     = ".",
})

-- Load-Balancing for Quad9
setServerPolicy(firstAvailable)

-- ==========================================
-- 3. ACCESS & ROUTING (The "Sandwich")
-- ==========================================

-- Server acl rules
addACL('0.0.0.0/0')
addACL('::/0')

-- RULE 1: Detect return path from Recursor
-- If the request originates from Localhost, the Recursor wants to access the Internet.
-- We forward these requests to the "quad9" pool.
addAction(DSTPortRule(5353), PoolAction("quad9"))

-- RULE 2: Standard Routing for Clients
-- Everything else (from the outside) goes FIRST to the Recursor,
-- so that RPZ and internal zones are processed.
addAction(AllRule(), PoolAction("recursor"))
