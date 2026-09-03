# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  bridge = "br-container";
in
{
  containers.ns = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;

    localMacAddress = "02:7e:7c:83:83:ec";

    config = { ... }: {
      imports = [ ../../modules/default-ct.nix ];
      maximizzar.modules.networking.containerInterface = {
        enable = true;
        dns = false;
      };

      services.dnsdist = {
        enable = true;
        listenAddress = "[::]";
        listenPort = 53;
        extraConfig = ''
          -- Backend-Server
          newServer({address = "[fd80:3aa8:691a:ff53:4b:64ff:fe2d:8169]:53", name = "resolver"})

          -- access rules
          setACL({"fd80:3aa8:691a:ff00::/56"})
        '';
      };
    };
  };

}
