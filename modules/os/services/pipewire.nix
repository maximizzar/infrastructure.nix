# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.pipewire;
in
{

  options.maximizzar.modules.services.pipewire = {
    enable = lib.mkEnableOption "Enable pipewire service for device";
  };

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = lib.mkDefault false;
    security.rtkit.enable = lib.mkDefault true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

}
