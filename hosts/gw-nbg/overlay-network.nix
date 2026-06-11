{ config, inputs, lib, ... }: let
    ipam = inputs.self.lib.ipam;
    sites = inputs.self.inventory.sites;
in {
  networking.wireguard.interfaces.wg0 = {
    peers = lib.mapAttrsToList (siteName: site:
      let
        router = site.routers.${site.primaryRouter};
      in {
        publicKey = router.wg.pubkey;

        allowedIPs = [
          (ipam.sitePrefix site)
        ];
      }
    ) (lib.filterAttrs (name: _: name != config.networking.hostName) sites);

      privateKeyFile = "/etc/wireguard/wg0.key";
  };
}
