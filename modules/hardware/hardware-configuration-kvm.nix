# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.maximizzar.modules.hardware.configuration.qemu;
in
{
  options.maximizzar.modules.hardware.configuration.qemu.enable = lib.mkEnableOption "qemu-config";
  config = lib.mkIf cfg.enable {
    imports = [
      inputs.nixos-facter-modules.nixosModules.facter
      { hardware.facter.reportPath = ./facter.json; }
    ];
  };
}
