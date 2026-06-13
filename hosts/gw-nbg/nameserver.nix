{ pkgs, inventory, ... }:
let
  hosts-nbg-lan = inventory.sites.nbg.router.interfaces.lan.hosts;
in
{
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.bind = {
    enable = true;

    zones."maximizzar.org" = {
      master = true;
      file = pkgs.writeText "zone-maximizzar.org" ''
        $ORIGIN maximizzar.org.
        $TTL 300

        @ IN SOA ns1.maximizzar.org. hostmaster.maximizzar.org. ( 1 3h 1h 1w 1h )

        @ IN NS ${hosts-nbg-lan.ns1.name}

        @ IN A 178.105.53.186
        @ IN AAAA 2a01:4f8:c2c:bd86::1

        ${hosts-nbg-lan.ns1.name} IN AAAA ${hosts-nbg-lan.ns1.ip}

      '';
    };
  };
}
