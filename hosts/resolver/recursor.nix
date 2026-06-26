# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inputs, pkgs, ... }:
let
  rpz = pkgs.replaceVars ./rpz.lua {
    hagezi-rpz = "${inputs.hagezi-rpz}";
  };
in
{

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.pdns-recursor = {
    enable = true;

    dns.port = 53;
    dnssecValidation = "log-fail";
    exportHosts = false;
    serveRFC1918 = true;
    luaConfig = builtins.readFile rpz;

    forwardZonesRecurse = {
      "." = "[2620:fe::11]:853#dns11.quad9.net;[2620:fe::fe:11]:853#dns11.quad9.net";
    };
  };
}
