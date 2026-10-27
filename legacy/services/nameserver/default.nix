# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.nameserver;
in
{
  imports = [
    ./ns-primary.nix
    ./networking.nix
  ];

  options.maximizzar.modules.services.nameserver = {
    enable = lib.mkEnableOption "Enable Namesever";
    openFirewall = lib.mkEnableOption "Open Ports in Firewall";

    primary = lib.mkEnableOption "Run Nameserver as Primary";
    secondary = lib.mkEnableOption "Run Nameserver as Secondary";

    serialNumber = lib.mkOption {
      type = lib.types.str;
      description = "The SOA Serial-number. Increase each iteration to update correctly!";
    };
  };

  config.services.bind.enable = cfg.enable;
  config.assertions = [
    {
      assertion = !(cfg.primary && cfg.secondary);
      message = "maximizzar.modules.services.nameserver.primary and maximizzar.modules.services.nameserver.secondary as mutually exclusive.";
    }
  ];

}
