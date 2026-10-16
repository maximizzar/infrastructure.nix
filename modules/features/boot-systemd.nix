# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.systemdBoot = { config, lib, ... }: {
    boot.loader.systemd-boot.enable = !config.boot.isContainer;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  };
}
