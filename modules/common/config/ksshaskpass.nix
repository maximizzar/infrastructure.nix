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
  cfg = config.maximizzar.modules.applications.ksshaskpass;
in
{
  options.maximizzar.modules.applications.ksshaskpass.enable =
    lib.mkEnableOption "Use ksshaskpass for SSH pass";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ kdePackages.ksshaskpass ];

    environment.sessionVariables = {
      SSH_ASKPASS = lib.mkDefault "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      SSH_ASKPASS_REQUIRE = lib.mkDefault "prefer";
    };

  };
}
