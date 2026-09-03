# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  bridge = "br-container";
  serial = "24";
in
{
  containers.nameserver = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;
    localMacAddress = "50:E5:75:61:13:C7";

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
        serialNumber = serial;
      };
    };
  };
}
