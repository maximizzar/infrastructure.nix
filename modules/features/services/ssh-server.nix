# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.sshServer = { lib, ... }: {
    services.openssh = {
      enable = lib.mkDefault true;
      openFirewall = true;
      settings = {
        X11Forwarding = false;
        UsePAM = true;
        UseDns = false;
        StrictModes = true;
        PrintMotd = false;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        LogLevel = "VERBOSE";
      };
      extraConfig = ''
        MaxAuthTries 3
        MaxSessions 2
        PubkeyAuthentication yes
        AllowAgentForwarding no
        AllowTcpForwarding no
        TCPKeepAlive no
        ClientAliveCountMax 2
      '';
    };

  };
}
