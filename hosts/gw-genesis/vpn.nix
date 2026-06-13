{ inventory, ... }:
let
  selfSite = inventory.sites.genesis;
  remoteSite = inventory.sites.nbg;
in
{
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces.wg0 = {
    ips = [ "${selfSite.router.interfaces.transit.address}/128" ];

    # WireGuard Port
    listenPort = 51820;

    # Path to the private key file.
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = [
      {
        publicKey = remoteSite.router.wgPubkey;

        allowedIPs = [
          inventory.networks.transit.cidr
          inventory.networks.overlay.cidr
        ];
        endpoint = "[2a01:4f8:c2c:bd86::1]:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
