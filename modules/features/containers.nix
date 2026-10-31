# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosModules.containers = { config, lib, ... }: {
    options.maximizzar.containers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hostBridge = lib.mkOption {
              type = lib.types.str;
              default = "br0";
            };

            localMacAddress = lib.mkOption {
              type = lib.types.str;
            };

            modules = lib.mkOption {
              type = lib.types.listOf lib.types.deferredModule;
              default = [ ];
            };
          };
        }
      );
      default = { };
    };

    config.containers = lib.mapAttrs (name: container: {
      autoStart = true;
      restartIfChanged = true;
      privateNetwork = true;
      inherit (container) hostBridge localMacAddress;

      specialArgs = { inherit self inputs; };
      config = {
        imports = container.modules ++ [
          self.nixosModules.container
        ];
        networking.hostName = name;
      };
    }) config.maximizzar.containers;
  };
}
