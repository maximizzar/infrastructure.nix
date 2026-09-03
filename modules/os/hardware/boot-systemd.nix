# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.hardware.bootSystemd;
in
{
  options.maximizzar.modules.hardware.bootSystemd.enable = lib.mkEnableOption "bootSystemd";
  config = lib.mkIf cfg.enable {
    # Bootloader settings for systemd-boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
