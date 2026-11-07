# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inventory, ... }: {
  flake.nixosModules.authConfiguration =
    {
      config,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.auth;
    in
    {
      imports = with self.nixosModules; [
        qemuVm
        authServer
        authSecrets
      ];

      disko.devices.disk.main = {
        imageSize = "10G";
      };

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;

        };
      };

      # Own custom Modules
      maximizzar = {
        # Enable various cli tools
        cliTooling = {
          enable = true;
        };

        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

        authServer = {
          enable = true;
          openFirewall = true;

          jwtSecretFile = config.sops.secrets."authelia/jwtSecret".path;
          oidcHmacSecretFile = config.sops.secrets."authelia/oidcHmacSecret".path;
          oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/oidcIssuerPrivateKey".path;
          sessionSecretFile = config.sops.secrets."authelia/sessionSecret".path;
          storageEncryptionKeyFile = config.sops.secrets."authelia/storageEncryptionKey".path;

          usersDatabase = config.sops.secrets."authelia/usersDatabase".path;
        };

        networking.default.MACAddress = host.MACAddress;
      };
    };
}
