# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.hardware.bootGrub;
in
{
  options.maximizzar.modules.hardware.bootGrub.enable = lib.mkEnableOption "bootGrub";
  config = lib.mkIf cfg.enable {
    boot.loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
