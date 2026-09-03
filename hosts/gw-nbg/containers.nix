# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  bridge = "br0";
  nameservers = [
    "fd80:3aa8:691a:fe00:bf:daff:feb2:a553"
  ];
in
{
  containers.resolver = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;

    localMacAddress = "02:bf:da:b2:a5:53";

    config = { ... }: {
      imports = [ ../../modules/default-ct.nix ];

      maximizzar.modules.networking.containerInterface = {
        enable = true;
        dns = false;
      };

      maximizzar.modules.services.resolver = {
        enable = true;
        openFirewall = true;

        forward_zones = [
          {
            zone = "maximizzar.org";
            forwarders = [
              "[fd80:3aa8:691a:fe00:1a:e1ff:fecf:1464]:53"
            ];
          }
        ];

      };

    };
  };

  containers.nameserver = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;

    localMacAddress = "02:1a:e1:cf:14:64";

    config = { ... }: {
      imports = [ ../../modules/default-ct.nix ];

      maximizzar.modules.networking.containerInterface = {
        enable = true;
        dns = false;
      };

      maximizzar.modules.services.nameserver = {
        enable = true;
        openFirewall = true;

        primary = true;
        serialNumber = "1";
      };

    };
  };

  containers.proxy = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;

    localMacAddress = "02:16:7b:2d:f7:6d";

    config = { ... }: {
      imports = [ ../../modules/default-ct.nix ];

      maximizzar.modules.networking.containerInterface = {
        enable = true;
        dns = false;
      };

    };
  };

  containers.pforgejo = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;

    localMacAddress = "02:37:9a:cc:7d:99";

    config = { ... }: {
      imports = [ ../../modules/default-ct.nix ];

      networking.nameservers = nameservers;
      maximizzar.modules.networking.containerInterface = {
        enable = true;
        dns = true;
      };

      # Proxy logic
      services.openssh.enable = false;
      networking.firewall.allowedTCPPorts = [ 22 ];
      services.nginx = {
        enable = true;
        streamConfig = ''
          server {
            listen [::]:22;
            proxy_connect_timeout 10s;
            proxy_timeout 20s;
            proxy_pass forgejo.srv.genesis.prod.maximizzar.org:22;
          }
        '';

      };

    };
  };

}
