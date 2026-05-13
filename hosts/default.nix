# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/default.nix
{ self, lib, inputs, ... }: let
    # This function allows you to build images (QCow2) for each host config
    hostNames = builtins.attrNames self.nixosConfigurations;
    makeImagePackage = name: {
        name = "${name}-image";
        value = self.nixosConfigurations.${name}.config.system.build.diskoImages;
    };

    # Modules that are active for all hosts
    commonModules = [
        # Admin users
        self.nixosModules.user-maximizzar

        inputs.disko.nixosModules.disko
        self.nixosModules.services-sshd
        self.nixosModules.system-nix-settings
        self.nixosModules.vars-pki
    ];

    # Modules only needed for QEMU VMs
    qemuvmModules = [
        self.nixosModules.hardware-qemu
        self.nixosModules.hardware-qemuDisk10gb
    ];

in {
    flake.nixosConfigurations = {
        # core
        core-gateway = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./core/gateway.nix
            ] ++ qemuvmModules;
        };


        core-ns-fw-primary = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                { _module.args = { hostname = "ns-primary"; ns-primary = "fd80:3aa8:691a:20:be24:11ff:fee8:c513"; }; }
                self.nixosModules.services-nameserver-forwarder
                self.nixosModules.networking-generic-interface-config
            ] ++ qemuvmModules;
        };

        core-ns-fw-secondary = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                { _module.args = { hostname = "ns-secondary"; ns-primary = "fd80:3aa8:691a:20:be24:11ff:fed9:139f"; }; }
                self.nixosModules.services-nameserver-forwarder
                self.nixosModules.networking-generic-interface-config
            ] ++ qemuvmModules;
        };



        core-ns-authoritive-primary = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = commonModules ++ [
                { _module.args = { hostname = "ns-primary"; }; }
                self.nixosModules.services-nameserver-authoritive
                self.nixosModules.networking-generic-interface-config
            ] ++ qemuvmModules;
        };

        core-ns-authoritive-secondary = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = commonModules ++ [
                { _module.args = { hostname = "ns-secondary"; }; }
                self.nixosModules.services-nameserver-authoritive
                self.nixosModules.networking-generic-interface-config
            ] ++ qemuvmModules;
        };


        core-prometheus = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./core/prometheus.nix
            ] ++ qemuvmModules;
        };


        # vc (Version Control)
        vc-forgejo = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./vc/forgejo.nix
                self.nixosModules.networking-generic-interface-config
            ] ++ qemuvmModules;
        };

        vc-woodpecker = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./vc/woodpecker.nix
            ] ++ qemuvmModules;
        };


        # web
        web-home-assistant = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./web/home-assistant.nix
            ] ++ qemuvmModules;
        };

        web-immich = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./web/immich.nix
            ] ++ qemuvmModules;
        };

        web-jellyfin = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./web/jellyfin.nix
            ] ++ qemuvmModules;
        };

        web-tubearchivist = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = commonModules ++ [
                ./web/tubearchivist.nix
            ] ++ qemuvmModules;
        };
    };

    perSystem = { system, ... }: {
        packages = lib.listToAttrs (map makeImagePackage hostNames);
    };
}
