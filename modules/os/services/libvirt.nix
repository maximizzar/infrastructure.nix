# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.maximizzar.modules.services.libvirt;
in
{
  options.maximizzar.modules.services.libvirt = {
    enable = lib.mkEnableOption "Enable libvirt based Virtualisation";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "maximizzar" ];
      description = "Users that can manage VMs.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    users.users = lib.genAttrs cfg.users (_u: {
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "kvm"
      ];
    });

    environment.systemPackages = with pkgs; [
      qemu
      virt-manager
      virt-viewer
      spice
      spice-gtk
      swtpm
    ];

  };
}
