# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.music-production =
    { config, lib, ... }:
    let
      modules = [
      ];
    in
    {
      imports = modules;
      musnix = {
        enable = true;
        alsaSeq.enable = true;
        kernel.realtime = lib.mkDefault true;
        rtirq.enable = config.musnix.kernel.realtime;
      };
    };
}
