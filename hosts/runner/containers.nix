# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  stateVersion,
  ...
}:
let
  bridge = "br-container";
in
{
  containers.runner01 = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;
    localMacAddress = "02:B1:1B:66:8F:AD";

    config = { ... }: {
      imports = [ ../../modules/default-container.nix ];

      maximizzar.modules.networking.containerInterface = {
        enable = true;
        dns = true;
      };

      maximizzar.modules.services.forgejoRunner = {
        enable = true;
        forgejoInstanceUrl = "https://forgejo.maximizzar.io";
        uuid = "b994f831-d0d1-49c8-a5ec-19a7f6b7606c";
      };

      system.stateVersion = stateVersion;
    };
  };

  containers.runner02 = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;
    localMacAddress = "02:0D:EE:FB:11:0D";

    config = { ... }: {
      imports = [ ../../modules/default-container.nix ];

      maximizzar.modules.networking.containerInterface = {
        enable = true;
        dns = true;
      };

      maximizzar.modules.services.forgejoRunner = {
        enable = true;
        forgejoInstanceUrl = "https://forgejo.maximizzar.io";
        uuid = "2e776556-9170-4622-bcd5-324f8c17ff02";
      };

      system.stateVersion = stateVersion;
    };
  };
}
