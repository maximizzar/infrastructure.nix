# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.vpn;
in
{
  networking.wireguard = lib.mkIf cfg.enable {
    inherit (cfg) enable;

    interfaces.wg0 = {
      allowedIPsAsRoutes = true;
      inherit (cfg) ips privateKeyFile;
      listenPort = cfg.port;

      peers = map (peer: {
        inherit (peer)
          publicKey
          allowedIPs
          persistentKeepalive
          endpoint
          ;
        name = "peer-${peer.name}";
      }) cfg.peers;
    };
  };

}
