# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inputs, self, ... }: {
  flake.nixosModules.host =
    let
      modules =
        with inputs;
        [
          musnix.nixosModules.musnix
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
        ]
        ++ (with self.nixosModules; [
          users
          base

          bash
          carapace
        ]);
    in
    {
      imports = modules;
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
      };

      # General sops options
      sops.age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
    };
}
