# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosModules.virtualization =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.maximizzar.virtualization;

      virtualizationGroups = lib.flatten [
        (lib.optionals (cfg.libvirt.enable) [
          "libvirtd"
          "kvm"
        ])
      ];
    in
    {
      options.virtualization = {
        enable = lib.mkEnableOption "Enable host for guest systems";
        libvirt = {
          enable = lib.mkEnableOption "Use libvirt for vm config";
          useVirtmanager = lib.mkEnableOption "Use virt-manager as mgnt UI";
          useLookingGlass = lib.mkEnableOption "Use looking-glass to view your VMs";
        };

        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Users that receive virtualization-related group memberships.";
        };

      };

      config = lib.mkIf cfg.enable {
        users.users = lib.mkIf (virtualizationGroups != [ ]) (
          lib.genAttrs cfg.users (_: {
            extraGroups = virtualizationGroups;
          })
        );

        virtualisation.libvirtd = {
          enable = cfg.libvirt.enable;
          qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
        };

        programs.virt-manager.enable = cfg.libvirt.useVirtmanager;
        environment.systemPackages = lib.optionals cfg.libvirt.useLookingGlass (
          with pkgs;
          [
            looking-glass-client
          ]
        );

      };

    };
}
